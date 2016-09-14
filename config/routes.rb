Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :annotation, controller: :annotations, defaults: {format: :json}
  get '/search', to: 'search#index', defaults: {format: :json}
  get '/search/:id', to: 'search#show', defaults: {format: :json}
end
