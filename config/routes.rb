Rails.application.routes.draw do
  resources :events
  devise_for :members

  get 'pages/home' , as: 'home'

  get 'pages/contact', as: 'contact'

  get 'members', to: 'pages#members', as: 'members'

  root 'pages#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
