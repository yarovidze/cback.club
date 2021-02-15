Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root "pages#index"
end

