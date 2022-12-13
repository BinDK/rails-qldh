class HomeController < ApplicationController
  before_action :http_auth

  include Pagy::Backend
  def index
    @new = Order.new_order_count
    @prepared = Order.prepared_order_count
    @shipped = Order.shipped_order_count
    @completed = Order.completed_order_count



  end
  def cus
    @pagy,@customers = pagy(Customer.all)

  end
  def ref
    @pagy,@refs = pagy(Referrer.all)

  end
  def new_order
    product_find(0)
    @customers = Customer.all
  end

  def product_manage
    @pagy,@products = pagy(Product.all)

  end

  def order_manage
    @entries = 3
    @pagy,@orders = pagy(Order.order(created_at: :desc).all_except('hoàn tất đơn'))
  end

  private
  def http_auth
    return true if Rails.env == "development"
    authenticate_or_request_with_http_basic do |username,password|
     username == Rails.application.credentials.dig(:http_auth,:uname).to_s &&
     password == Rails.application.credentials.dig(:http_auth,:pass).to_s
  end
  end


  # 0 to find all
  # other number to find specific product
  def product_find(desire)
    if desire == 0
      @products = Product.all.order(:created_at)
      return  @products
    else
      @product = Product.find(desire)
      return  @product
    end

  end
end
