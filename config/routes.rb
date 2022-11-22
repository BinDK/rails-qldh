Rails.application.routes.draw do

  scope :home do

    scope :api do
      get 'testt', to: 'apix#testt'
      get 'phone_check', to: 'apix#phone_check'
      get 'ref_phone_check', to: 'apix#ref_phone_check'

      get 'product_info', to: 'apix#product_info'

      post 'customer_check', to: 'apix#customer_check'

    end

    get 'index', to: 'home#index'

    get 'new_order', to: 'home#new_order'


  end

  root 'home#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
