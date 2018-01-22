Rails.application.routes.draw do
  # if route defined after, it will be interpreted as events/(:id = search)
  get 'events/search', as: 'search'
  # delete event or events with multi dates
  get 'events/delete/:id/:type_update(.:format)', to: 'events#destroy_events', as: 'delete_events'

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
  get 'pages/smihug', as: 'smihug'
  get 'pages/contact', as: 'contact'
  post 'pages/contact', to: 'pages#send_mail_contact'
  get 'pages/forbidden', as: 'forbidden'

  get 'participate', to: 'events#participate', as: 'participate'
  get 'interact_with/:id/:type', to: 'events#interact_with', as: 'interact_with'

  root 'pages#home'
end
