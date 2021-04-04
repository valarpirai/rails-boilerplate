Rails.application.routes.draw do
  root to: 'home#index'

  get '/accounts/signup' => 'accounts#new'
  post '/accounts/signup' => 'accounts#signup'

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  # To Override - configure other modules
  devise_for :users, controllers: {
    sessions: 'users/sessions', registrations: 'users/registrations', confirmations: 'users/confirmations', passwords: 'users/passwords', unlocks: 'users/unlocks'
  }

  get '/login/normal' => 'users/sessions#new', as: :login_normal, constraints: lambda {|req| req.format == :html }

  resources :projects do
    member do
      post :search_flags
    end
    resources :feature_flags, except: [:index] do
      member do
        get :edit_properties
        post :update_properties
      end
    end
    post :change_environment
    resources :environments, except: [:index, :show, :edit, :update] do
      post :enable_flag
      post :disable_flag
      get :show_flag_configs
      post :update_flag_configs
    end
  end

  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
