RailsIds::Engine.routes.draw do
  resource :dashboard, only: [:show]

  resources :attacks, only: [:index, :show]
  resources :events, only: [:index, :show]

  root 'dashboard#show'
end
