# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get '/contacts', to: 'contacts#new'
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
  get 'auth_admitad', to: 'admins#auth_admitad', as: 'authorisation_admitad'
  post 'admitad_action_data', to: 'admins#admitad_action_data', as: 'admitad_action_data'
  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations',
                            sessions: 'users/sessions' }
  devise_scope :user do
    get '/users', to: 'devise/registrations#new'
    get '/users/password', to: 'devise/passwords#new'
  end
  root 'offers#index'
  get '/agreement', to: 'pages#agreement', as: 'agreement'
  # page error messages
  match '/404', to: 'errors#not_found', via: :all
  match '/422', to: 'errors#unacceptable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  resources :favorites
  resources :users, only: %i[show]
  resources :categories
  resources :contacts, only: %i[new create]
  get 'categories/show'
  resources :offers do
    get 'search', on: :collection
  end
end
