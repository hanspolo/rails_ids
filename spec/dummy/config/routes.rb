Rails.application.routes.draw do
  mount RailsIds::Engine => '/rails_ids'

  resources :posts, only: [:index, :show, :new, :create]
  resources :users, only: [:create]
end
