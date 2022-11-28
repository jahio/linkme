Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post "/links", to: 'links#create'
  get "/links/:shortpath", to: 'links#show'
end
