Rails.application.routes.draw do
  devise_for :users
  root to: 'establishments#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :establishments, except: [:show]
  get 'establishments/search', to: 'establishments#search', as: 'establishments_search'
  post 'establishments/import_csv', to: 'establishments#import_csv', as: 'establishments_import_csv'
end
