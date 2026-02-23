Rails.application.routes.draw do
  # Health check
  get '/health', to: proc { [200, {}, ['Gateway OK']] }
  
  # ============================================
  # AUTH ROUTES (public, sans authentification)
  # ============================================
  post '/signup', to: 'gateway#signup'
  post '/login',  to: 'gateway#login'
  post '/verify', to: 'gateway#verify'
  
  # ============================================
  # PROJECTS ROUTES (authentifiées)
  # ============================================
  get    '/projects',     to: 'gateway#projects_index'
  get    '/projects/:id', to: 'gateway#projects_show'
  post   '/projects',     to: 'gateway#projects_create'
  put    '/projects/:id', to: 'gateway#projects_update'
  patch  '/projects/:id', to: 'gateway#projects_update'
  delete '/projects/:id', to: 'gateway#projects_destroy'
  
  # ============================================
  # TASKS ROUTES (authentifiées)
  # ============================================
  get    '/projects/:project_id/tasks', to: 'gateway#tasks_index'
  post   '/projects/:project_id/tasks', to: 'gateway#tasks_create'
  get    '/tasks/:id',                  to: 'gateway#tasks_show'
  put    '/tasks/:id',                  to: 'gateway#tasks_update'
  patch  '/tasks/:id',                  to: 'gateway#tasks_update'
  delete '/tasks/:id',                  to: 'gateway#tasks_destroy'
  patch  '/tasks/:id/toggle',           to: 'gateway#tasks_toggle'
end