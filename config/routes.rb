Rails.application.routes.draw do
  root 'admin/homes#index'
  namespace :admin do
    root 'homes#index'

    resources :orders
    resources :referrers
    resources :customers
    resources :products
  end

  scope :home do
    # root 'admin/home#index'
    # get 'index', to: 'home#index'
  end

  namespace :api do

    post 'add_order', to: 'api#add_order'
    get 'phone_check', to: 'api#phone_check'
    get 'ref_phone_check', to: 'api#ref_phone_check'
    get 'product_info', to: 'api#product_info'
    post 'customer_check', to: 'api#customer_check'
    get 'customer_address', to: 'api#customer_address'
    get 'cus_name_search', to: 'api#cus_name_search'
    get 'ref_name_search', to: 'api#ref_name_search'


    # post 'add_prod', to: 'api#add_prod'
    # get 'find_prod', to: 'api#find_prod'
    # put 'update_prod', to: 'api#update_prod'
    # delete 'delete_prod', to: 'api#delete_prod'
    # get 'prod_page', to: 'api#prod_page'
    resources :products

    namespace :orders do
      get 'find_order', to: 'find_order'
      get 'find_oder_kw', to: 'find_oder_kw'
      put 'change_order_stat', to: 'change_order_stat'
      get 'find_order_by_stat', to: 'find_order_by_stat'
      get 'order_page', to: 'order_page'
    end

    get 'cus_search', to: 'api#cus_search'
    get 'ref_search', to: 'api#ref_search'
    put 'cus_info', to: 'api#cus_info_update'
    put 'cus_addr', to: 'api#cus_addr_update'
    put 'ref_info', to: 'api#ref_info_update'
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
    # get 'product_detail', to: 'home#product_detail'
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
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
