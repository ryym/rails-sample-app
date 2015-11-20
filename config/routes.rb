Rails.application.routes.draw do
  root              'static_pages#home'
  get  'help'    => 'static_pages#help'
  get  'about'   => 'static_pages#about'
  get  'contact' => 'static_pages#contact'
  get  'signup'  => 'users#new'
  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :users do
    member do
      # Add a route like '/usrs/1/following'.
      get :following, :followers
    end
    # To add a route like '/users/tigers',
    # use the 'collection' block instead of the 'member'.
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
end
