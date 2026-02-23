Rails.application.routes.draw do
  post '/signup', to: 'auth#signup'
  post '/login', to: 'auth#login'
  post '/verify', to: 'auth#verify'
  
  get '/health', to: proc { [200, {}, ['OK']] }
end