Rails.application.routes.draw do
  devise_for :users

  get 'prousts/about', as: :about

  get 'address/show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'prousts/new'
  get 'prousts/rec', as: :proust_rec
  get 'prousts/:id/show', to: 'prousts#show', as: :proust_show
  get 'prousts/:id/common_posts_index', to: 'prousts#common_posts_index'
  get 'prousts/:id/common_posts_show', to: 'prousts#common_posts_show'
  get '/', to: 'prousts#map', as: :map

  post 'prousts/create', as: :proust

  post 'prousts/convert'

end


