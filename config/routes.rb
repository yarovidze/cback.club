# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get 'offers/index'
  get 'offers/show'
  get 'offers/offer_redirect', to: 'offers#offer_redirect', as: 'redirect'
  get 'autocomplete', to: 'offers#autocomplete', as: 'autocomplete'

  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations',
                            sessions: 'users/sessions' }

  root 'offers#index'
  resources :favorites
  resources :categories
  get 'categories/show'
  resources :offers do
    get 'search', on: :collection
  end
end
