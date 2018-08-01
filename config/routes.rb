Rails.application.routes.draw do
  resources :paintings
  get 'draw' => 'canvas#draw'
  root 'welcome#index'
  get 'your_paintings' => 'paintings#index'


  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
