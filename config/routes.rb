Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions:  'users/sessions',
    registrations: 'users/registrations'
  }


  get 'prousts/about', as: :about

  get 'prousts/new'
  get 'prousts/rec', as: :proust_rec
  get 'prousts/:id/show', to: 'prousts#show', as: :proust_show
  get 'prousts/:id/common_posts_index', to: 'prousts#common_posts_index'
  get 'prousts/:id/common_posts_show', to: 'prousts#common_posts_show'
  get '/', to: 'prousts#map', as: :map

  post 'prousts/create', as: :proust

  post 'prousts/convert'

  delete '/prousts/:id/delete', to: 'prousts#destroy', as: :proust_delete

end


