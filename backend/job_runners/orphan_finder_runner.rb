require_relative 'orphan_generator'
require 'json'

class OrphanFinderRunner < JobRunner

  include JSONModel

  register_for_job_type('orphan_finder_job',
                          :run_concurrently => true)

  def self.orphans
   OrphanManager.registered_orphans
  end

  def run

    file = ASUtils.tempfile('orphan_finder_job_')

    begin

      job_data = @json.job

      # we need to massage the json sometimes..
      begin
        params = ASUtils.json_parse(@json.job_params[1..-2].delete("\\"))
      rescue JSON::ParserError
        params = {}
      end
      params[:format] = job_data['format']
      params[:repo_id] = @json.repo_id

      log(Time.now)
      # Maybe add a title field to job_data to make this prettier
      @job.write_output("Found the following #{job_data['orphan_type']}:")

      orphan_model = OrphanFinderRunner.orphans[job_data['orphan_type']][:model]

      orphan = DB.open do |db|
        orphan_model.new(params, @job, db)
      end

      file = ASUtils.tempfile('orphan_finder_job_')
      OrphanGenerator.new(orphan).generate(file)

      file.rewind
      @job.write_output('Adding csv file.')

      @job.add_file(file)

      self.success!

      orphan_logger(orphan)

      log("===")

      # @job.write_output("Generating csv of orphaned  records.")
      # file = ASUtils.tempfile("orphan_job_")
      # OrphanGenerator.new(@orphan).generate_csv(file)
      # @job.write_output("Linking to orphaned records csv.")
      # @job.add_file( file )

      self.success!
    rescue Exception => e
      @job.write_output(e.message)
      @job.write_output(e.backtrace)
      raise e
    ensure
      file.close
      file.unlink
      @job.write_output("Done.")
    end
  end

  def log(s)
    Log.debug(s)
    @job.write_output(s)
  end

  def orphan_logger(orphan)
    results = orphan.get_content
    results.each do |result|
      line = []
      result.each do |_key, value|
        line.push(value.is_a?(Array) ? ASUtils.to_json(value) : value)
      end
      @job.write_output("#{line}")
    end
  end

end
