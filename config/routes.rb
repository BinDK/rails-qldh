Rails.application.routes.draw do
  root 'home#index'

  scope :home do
    scope :api do
      get 'index', to: 'apix#index'
    end

    get 'index', to: 'home#index'

    get 'new_order', to: 'home#new_order'


  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
