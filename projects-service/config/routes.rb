Rails.application.routes.draw do
  resources :projects, only: [:index, :show, :create, :update, :destroy]
  
  get '/health', to: proc { [200, {}, ['OK']] }
end