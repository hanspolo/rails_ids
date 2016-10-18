RailsIds::Engine.routes.draw do
  resource :dashboard, only: [:show]

  resources :attacks, only: [:index, :show]
  resources :events, only: [:index, :show] do
    member do
      get 'verify', as: 'verify', action: 'verify'
      get 'deny', as: 'deny', action: 'deny'
    end
  end
  resources :machine_learning_examples, only: [:index, :new, :create, :edit, :update] do
    collection do
      get 'import', as: 'new_import', action: 'new_import'
      post 'import'
    end
  end

  root 'dashboard#show'
end
