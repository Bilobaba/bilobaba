Rails.application.routes.draw do
  resources :events
  devise_for :members

  devise_scope :member do
    resources :members, only: %i[show index]
  end

  get 'pages/home', as: 'home'
  get 'pages/contact', as: 'contact'

  root 'pages#home'
end
