Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  get '/ping', to: 'tennis_table#ping'

  namespace :v1 do
    resources :classifieds, only: [ :index, :show, :create, :update, :destroy ]
    resources :users, only: :show
  end
end
