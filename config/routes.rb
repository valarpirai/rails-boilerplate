Rails.application.routes.draw do
  root to: 'home#index'

  get '/accounts/signup' => 'accounts#new'
  post '/accounts/signup' => 'accounts#signup'

  # To Override - configure other modules
  devise_for :users, controllers: {
    sessions: 'users/sessions', registrations: 'users/registrations', confirmations: 'users/confirmations', passwords: 'users/passwords', unlocks: 'users/unlocks'
  }

  get '/login/normal' => 'users/sessions#new', as: :login_normal, constraints: lambda {|req| req.format == :html }

  resources :projects do
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
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
