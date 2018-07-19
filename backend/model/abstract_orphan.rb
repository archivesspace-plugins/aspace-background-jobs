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

  def self.initialize(params, job, db)
    @repo_id = params[:repo_id] if params.has_key?(:repo_id) && params[:repo_id] != ''
    @format = params[:format] if params.has_key?(:format) && params[:format] != ''
    @params = params
    @db = db
    @job = job
    @info = {}
  end

  def self.current_user
    @job.owner
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

  def self.query(db = @db)
    raise 'Please specify a query to return your orphanable results'
  end

  def code
    self.class.code
  end

  def self.code
    self.name.gsub(/(.)([A-Z])/,'\1_\2').downcase
  end

  def self.repository
    Repository.get_or_die(repo_id).name
  end

  def fix_row(row); end

  def after_tasks; end

end
