Rails.application.routes.draw do
  # if route defined after, it will be interpreted as events/(:id = search)
  get 'events/search', as: 'search'
  # delete event or events with multi dates
  get 'events/delete/:id/:type_update(.:format)', to: 'events#destroy_events', as: 'delete_events'
  get 'events/duplicate/:id', to: 'events#duplicate', as: 'duplicate'
  resources :events do
    resources :comments
  end


  get 'members/index_pros', as: 'pros'
  get 'members/index_amateurs', as: 'amateurs'

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
  get 'pages/pricing', as: 'pricing'
  get 'pages/smihug', as: 'smihug'
  get 'pages/contact', as: 'contact'
  get 'pages/news', as: 'news'
  get 'pages/cgu', as: 'cgu'
  get 'pages/confidentiality', as: 'confidentiality'
  post 'pages/contact', to: 'pages#send_mail_contact'
  get 'pages/forbidden', as: 'forbidden'
  get 'pages/permission', as: 'permission'
  root 'events#index'
end
