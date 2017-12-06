Rails.application.routes.draw do
  resources :events do
    resources :comments
  end

  devise_for :members

  devise_scope :member do
    resources :members, only: %i[show index]
  end

  get 'pages/home', as: 'home'
  get 'pages/contact', as: 'contact'
  post 'pages/contact', to: 'pages#send_mail_contact'

  get 'participate', to: 'events#participate', as: 'participate'

  root 'pages#home'
end
