Rails.application.routes.draw do

  get 'offers/show'
  get 'autocomplete', to: 'offers#autocomplete', as: 'autocomplete'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',registrations: 'users/registrations', sessions: 'users/sessions' }
  devise_scope :user do
    get '/users/sign_out' => 'users/sessions#destroy'
  end
  ActiveAdmin.routes(self)
  root "offers#index"

  resources :offers do
    get 'search', on: :collection
  end
end

