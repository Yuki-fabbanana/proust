Rails.application.routes.draw do
  get 'address/show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'prousts/show'
  get 'prousts/rec'

  post 'prousts/convert'
end


