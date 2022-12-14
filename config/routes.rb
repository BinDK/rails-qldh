Rails.application.routes.draw do

  scope :home do

    scope :api do

      post 'add_order', to: 'apix#add_order'
      get 'phone_check', to: 'apix#phone_check'
      get 'ref_phone_check', to: 'apix#ref_phone_check'
      get 'product_info', to: 'apix#product_info'
      post 'customer_check', to: 'apix#customer_check'
      get 'customer_address', to: 'apix#customer_address'
      get 'cus_name_search', to: 'apix#cus_name_search'
      get 'ref_name_search', to: 'apix#ref_name_search'


      post 'add_prod', to: 'apix#add_prod'
      get 'find_prod', to: 'apix#find_prod'
      put 'update_prod', to: 'apix#update_prod'
      delete 'delete_prod', to: 'apix#delete_prod'
      get 'prod_page', to: 'apix#prod_page'

      get 'find_order', to: 'apix#find_order'
      get 'find_oder_kw', to: 'apix#find_oder_kw'

      put 'change_order_stat', to: 'apix#change_order_stat'
      get 'find_order_by_stat', to: 'apix#find_order_by_stat'
      get 'order_page', to: 'apix#order_page'

      get 'cus_search', to: 'apix#cus_search'
      get 'ref_search', to: 'apix#ref_search'
      put 'cus_info', to: 'apix#cus_info_update'
      put 'cus_addr', to: 'apix#cus_addr_update'
      put 'ref_info', to: 'apix#ref_info_update'

    end

    get 'index', to: 'home#index'

  end

  scope :orders do
    get 'new_order', to: 'home#new_order'
    get 'order_manage', to: 'home#order_manage'
    get 'order_detail', to: 'home#order_detail'

  end

  scope :product do
    get 'product_manage', to: 'home#product_manage'
    get 'new', to: 'home#new_product'
    post 'save_product', to: 'home#save_product'
    get 'product_detail', to: 'home#product_detail'
    put 'update_product', to: 'home#update_product'
  end

  scope :customers do
    get 'cus_manage', to: 'home#cus'
    get 'customer_detail', to: 'home#customer_detail'
    put 'update_customer', to: 'home#update_customer'
    put 'update_customer_addr', to: 'home#update_customer_addr'

  end

  scope :ref do
    get 'ref_manage', to: 'home#ref'
    get 'ref_detail', to: 'home#ref_detail'
    put 'update_ref', to: 'home#update_ref'

    put 'update_customer_addr', to: 'home#update_customer_addr'

  end

  root 'home#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
