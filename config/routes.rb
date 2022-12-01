Rails.application.routes.draw do

  scope :home do

    scope :api do

      get 'add_order', to: 'apix#add_order'
      get 'phone_check', to: 'apix#phone_check'
      get 'ref_phone_check', to: 'apix#ref_phone_check'
      get 'product_info', to: 'apix#product_info'
      post 'customer_check', to: 'apix#customer_check'
      get 'customer_address', to: 'apix#customer_address'


      post 'add_prod', to: 'apix#add_prod'
      get 'find_prod', to: 'apix#find_prod'
      put 'update_prod', to: 'apix#update_prod'
      delete 'delete_prod', to: 'apix#delete_prod'

      get 'find_order', to: 'apix#find_order'
      put 'change_order_stat', to: 'apix#change_order_stat'

    end


    get 'index', to: 'home#index'

    get 'new_order', to: 'home#new_order'

    get 'product_manage', to: 'home#product_manage'

    get 'order_manage', to: 'home#order_manage'

  end

  root 'home#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
