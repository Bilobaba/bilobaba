Rails.application.routes.draw do
  resources :events do
    resources :comments
  end

  devise_for :members, controllers: {
    registrations: 'registrations',
    sessions: 'sessions'
  }

  devise_scope :member do
    resources :members, only: %i[show index]
  end

  # Stripe
  resources :charges

  get 'pages/home', as: 'home'
  get 'pages/team', as: 'team'
  get 'pages/search', as: 'search'
  get 'pages/contact', as: 'contact'
  post 'pages/contact', to: 'pages#send_mail_contact'
  get 'pages/forbidden', as: 'forbidden'

  get 'participate', to: 'events#participate', as: 'participate'
  get 'interact_with/:id/:type', to: 'events#interact_with', as: 'interact_with'

  root 'pages#home'
end
