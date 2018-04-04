Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :books, except: :delete do
    get 'report', on: :collection
  end
  resources :authors, only: :index

  root to: 'books#index'
end
