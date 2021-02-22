Rails.application.routes.draw do

  get 'offers/index'
  get 'offers/show'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  ActiveAdmin.routes(self)
  root "offers#index"
  resources :offers do
    get :search, on: :collection
  end
end

