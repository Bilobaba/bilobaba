Rails.application.routes.draw do
  resources :view_data
  resources :taggings
  resources :tags
  resources :topics, except: :show
  resources :categories
  get 'topics/:topic', to: 'testimonials#index'


  resources :testimonials
  # if route defined after, it will be interpreted as events/(:id = search)
  get 'events/search', as: 'search'
  # delete event or events with multi dates
  get 'events/delete/:id/:type_update(.:format)', to: 'events#destroy_events', as: 'delete_events'
  get 'events/:id/duplicate', to: 'events#duplicate', as: 'duplicate'
  get 'events/show2/:id', to: 'events#show2', as: 'show2'
  resources :events do
    resources :comments
  end

  get 'members/index_pros', as: 'pros'
  get 'members/index_amateurs', as: 'amateurs'
  get 'members/:id/edit', to: 'members#edit',  as: 'member_edit'
  patch 'members/:id', to: 'members#update'

  devise_for :members, controllers: {
    registrations: 'registrations',
    sessions: 'sessions',
    omniauth_callbacks: 'members/omniauth_callbacks'
  }

  devise_scope :member do
    resources :members, only: %i[show index]
  end

  # Stripe
  # resources :charges

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
  get 'pages/test', as: 'test'
  get 'pages/errors_member', as: 'errors_member'
  get 'pages/home_awesome', as: 'home_awesome'
  get 'pages/faqs', as: 'faqs'
  root 'events#index'
end
