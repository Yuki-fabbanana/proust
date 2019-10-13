Rails.application.routes.draw do
  get 'address/show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'prousts/new'
  get 'prousts/show'
  get 'prousts/rec', as: :proust_rec
  get 'prousts/map', as: :map
  post 'prousts/create', as: :proust

  post 'prousts/convert'

end


