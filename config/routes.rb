Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  get '/ping', to: 'tennis_table#ping'

  resources :classifieds, only: [:index, :show, :create, :update, :destroy]
end
