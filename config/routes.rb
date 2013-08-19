Fileshare::Application.routes.draw do
  resources :bundles, only: [:new, :create, :show] do
    post :check, on: :member
    get :remove, on: :member
    resources :slots, only: [] do
      get :download, on: :member
    end
  end
  root to: 'bundles#new'
end
