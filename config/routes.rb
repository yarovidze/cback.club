Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  ActiveAdmin.routes(self)
  root "pages#index"
end

