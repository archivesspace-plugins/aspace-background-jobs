ArchivesSpace::Application.routes.draw do
  scope AppConfig[:frontend_proxy_prefix] do
    match('/plugins/aspace_background_jobs' => 'aspace_background_jobs#_form', :via => [:get])
  end
end
