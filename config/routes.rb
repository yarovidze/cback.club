Rails.application.routes.draw do
  ActiveAdmin::Devise.config
  
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  root "pages#index"
end

