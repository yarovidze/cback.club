Rails.application.routes.draw do

  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'contact/new'
  get 'offers/index'
  get 'offers/show'
  get 'autocomplete', to: 'offers#autocomplete', as: 'autocomplete'
  # offer invisible redirect
  get 'offers/offer_redirect', to: 'offers#offer_redirect', as: 'redirect'
  # filter for users transactions
  get 'filter_status', to: 'users#filter_status', as: 'filter_status'
  # liqpay routes
  get 'withdrawal', to: 'users#create_withdrawal_request'
  post 'withdrawal_liqpay', to: 'users#withdrawal_liqpay', as: 'withdrawal_liqpay'
  post 'withdrawal_get', to: 'admins#withdrawal_get', as: 'withdrawal_get'
  # admitad routes
  get 'admin_panel', to: 'admins#index', as: 'admin_panel'
  get 'autorisation_admitad', to: 'admins#autorisation_admitad', as: 'autorisation_admitad'
  post 'get_action_data', to: 'admins#get_action_data', as: 'get_action_data'
  get 'rec_user_actions_test', to: 'admins#rec_user_actions_test', as: 'rec_user_actions_test'

  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations',
                            sessions: 'users/sessions' }
  devise_scope :user do
  get '/users', to: 'devise/registrations#new'
  get '/users/password', to: 'devise/passwords#new'
end
  root 'offers#index'
  get '/agreement', to: 'pages#agreement', as: "agreement"
  # page error messages
  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#unacceptable", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  resources :favorites
  resources :users, only: %i[show]
  resources :categories
  resources :contacts, only: [:new, :create]
  get 'categories/show'
  resources :offers do
    get 'search', on: :collection
  end

end
