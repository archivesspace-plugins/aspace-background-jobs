class SubjectOrphan < AbstractOrphan

  register_orphan

  def initialize
    @repo_id = params[:repo_id] if params.has_key?(:repo_id) && params[:repo_id] != ''
    @format = params[:format] if params.has_key?(:format) && params[:format] != ''
    @params = params
    @db = db
    @job = job
    @info = {}
  end

  def self.get_content
    array = []
    query.each do |result|
      row = result.to_hash
      fix_row(row)
      array.push(row)
    end
    info[:repository] = repository
    after_tasks
    array
  end

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
      *
    FROM
      subject
    WHERE
      subject.id
    NOT IN
      (SELECT subject_id FROM subject_rlshp)"
  end

  # Sequel style:
  #               db[:subject].where(id: db[:subject_rlshp].select(:subject_id)).invert.all
  #             end
  #   end
  # end

end
