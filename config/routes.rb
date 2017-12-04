Rails.application.routes.draw do
  resources :events
  devise_for :members, controllers: { sessions: 'members/sessions' }
  
  get 'pages/home' , as: 'home'
  get 'pages/contact', as: 'contact'

  root 'pages#home'
end
