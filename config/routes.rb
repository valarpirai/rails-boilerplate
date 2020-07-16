Rails.application.routes.draw do
  root to: 'home#index'

  get '/accounts/new' => 'accounts#new'
  post '/accounts/signup' => 'accounts#signup'

  devise_for :users

  get '/login' => 'user_session#new', as: :login
  get '/login/normal' => 'user_session#new', as: :login_normal, constraints: lambda {|req| req.format == :html }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
