class OrphansController < JobsController

  set_access_control "view_repository" => [:index, :show, :log, :status, :records, :download_file ]
  set_access_control "create_job" => [:new, :create]
  set_access_control "cancel_job" => [:cancel]

  def new
    @job = JSONModel(:job).new._always_valid!
    @orphan_data = JSONModel::HTTP::get_json("/orphans")
  end

  def create

    job_data = params[params['job']['job_type']]

  end


  def show
    @job = JSONModel(:job).find(params[:id], "resolve[]" => "repository")
    @files = JSONModel::HTTP::get_json("#{@job['uri']}/output_files")
  end


  def cancel
    Job.cancel(params[:id])

    redirect_to :action => :show
  end

end
