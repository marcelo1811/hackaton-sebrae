Rails.application.routes.draw do
  devise_for :users
  root to: 'establishments#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :establishments
  post 'establishments/import_csv', to: 'establishments#import_csv', as: 'establishments_import_csv'
end
