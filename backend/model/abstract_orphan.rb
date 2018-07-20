require_relative 'orphan_manager'

class AbstractOrphan
  include OrphanManager::Mixin
  include JSONModel

  attr_accessor :repo_id
  attr_accessor :format
  attr_accessor :params
  attr_accessor :db
  attr_accessor :job
  attr_accessor :info

  def initialize(params, job, db)
    @repo_id = params[:repo_id] if params.has_key?(:repo_id) && params[:repo_id] != ''
    @format = params[:format] if params.has_key?(:format) && params[:format] != ''
    @params = params
    @db = db
    @job = job
    @info = {}
  end

  def current_user
    @job.owner
  end

  def get_content
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

  def query(db = @db)
    raise 'Please specify a query to return your orphanable results'
  end

  def code
    self.class.code
  end

  def self.code
    self.name.gsub(/(.)([A-Z])/,'\1_\2').downcase
  end

  def repository
    Repository.get_or_die(repo_id).name
  end

  def fix_row(row); end

  def after_tasks; end

end

class InstanceOrphan < AbstractOrphan

  register_orphan

end

class ArchivalObjectOrphan < AbstractOrphan

  register_orphan

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
      *
    FROM
      archival_object
    WHERE
      parent_name
    LIKE
      '%orphan%';"
  end

end

class SubjectOrphan < AbstractOrphan

  register_orphan

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

end

class PersonOrphan < AbstractOrphan

  register_orphan

end
