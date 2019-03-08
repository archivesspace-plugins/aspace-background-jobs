require_relative '../lib/orphan_generator'
require 'json'

class OrphanFinderRunner < JobRunner

  include JSONModel
  include CrudHelpers
  include RESTHelpers::ResponseHelpers

  register_for_job_type('orphan_finder_job',
                        :create_permissions => :manage_repository,
                        :cancel_permissions => :manage_repository,
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
      params[:run_type] = job_data['run_type']
      params[:format] = job_data['format']
      params[:repo_id] = @json.repo_id

      log(Time.now)

      type_title = I18n.t("orphans.#{job_data['orphan_type']}.title", :default => job_data['orphan_type'])
      @job.write_output("Found the following #{type_title}:")

      orphan_model = OrphanFinderRunner.orphans[job_data['orphan_type']][:model]

      orphan = DB.open do |db|
        orphan_model.new(params, @job, db)
      end

      if params[:run_type] == 'review_run'
        file = ASUtils.tempfile('orphan_finder_job_')
        OrphanGenerator.new(orphan).generate(file)

        file.rewind
        @job.write_output('Adding csv file.')

        @job.add_file(file)

        self.success!
      end

      if params[:run_type] == 'test_run'
        orphan_logger(orphan)

        self.success!
      end

      if params[:run_type] == 'execute_run'
        orphan_deleter(orphan)

        self.success!
      end

      log("===")

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

  def orphan_deleter(orphan)
    results = orphan.get_content
    results.each do |result|
      @job.write_output("Deleting #{result}")
      RequestContext.open(:current_username => @job.owner.username,
                          :repo_id => @job.repo_id) do
                            orphan.parent_class[result[:id]].delete
                          end
    end
  end

end
