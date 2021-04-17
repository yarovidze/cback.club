Rails.application.routes.draw do

  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'contact/new'
  get 'offers/index'
  get 'offers/show'
  get 'autocomplete', to: 'offers#autocomplete', as: 'autocomplete'
  get 'offers/offer_redirect', to: 'offers#offer_redirect', as: 'redirect'
  get 'withdrawal', to:'users#create_withdrawal_request'
  get 'filter_status', to: 'users#filter_status', as: 'filter_status'
  get 'withdrawal_liqpay', to: 'users#withdrawal_liqpay', as: 'withdrawal_liqpay'
  post 'withdrawal_get', to: 'admins#withdrawal_get', as: 'withdrawal_get'


  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations',
                            sessions: 'users/sessions' }
  root 'offers#index'
  get '/agreement', to: 'pages#agreement', as: "agreement"
  resources :favorites
  resources :users, only: %i[show]
  resources :categories
  resources :contacts, only: [:new, :create]
  get 'categories/show'
  resources :offers do
    get 'search', on: :collection
  end

end
