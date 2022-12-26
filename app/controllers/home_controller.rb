class HomeController < ApplicationController
  before_action :http_auth

  include Pagy::Backend
  def index
    @new = Order.new_order_count
    @prepared = Order.prepared_order_count
    @shipped = Order.shipped_order_count
    @completed = Order.completed_order_count
  end
  #Customer
  def cus
    @q = Customer.all.ransack(params[:q])
    @pagy,@customers = pagy(@q.result.order(created_at: :desc))

  end
  def customer_detail
    @customer = Customer.find(params[:id])
    @addr = Address.where(customer_id: @customer.id)
    @addr2 = Address.where(customer_id: @customer.id).to_json

    @orders = Order.order(created_at: :desc).where(customer_id: @customer.id).to_json
    render 'home/customer/detail'
  end
  def update_customer

  end

  def update_customer_addr

  end

  #end Product
  def ref
    @q = Referrer.all.ransack(params[:q])
    @pagy,@refs = pagy(@q.result.order(created_at: :desc))

  end
  def new_order
    product_find(0)
    @customers = Customer.all

  end

  #Product
  def product_manage
    @q = Product.all.ransack(params[:q])
    @pagy,@products = pagy(@q.result.order(created_at: :desc))
    render 'home/products/product_manage'
  end
  def new_product
    @product = Product.new
    render 'home/products/newp', {product: @product}
  end
  def save_product
    @product = Product.new(product_params)
    @product.price = params[:product][:price].to_s.gsub('.','').to_f/1000
    respond_to do |format|
      if @product.save
        format.html { redirect_to product_manage_path }

      else
        format.html { render 'home/products/newp', status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
  def product_detail
    @product = Product.find(params[:id])
    render 'home/products/editp'
  end
  def update_product
    @product = Product.find(params[:product][:id].to_s.to_i)
    pricex = params[:product][:price].to_s.gsub('.','').to_f/1000
    respond_to do |format|
      if @product.update(name: params[:product][:name],
                         price: pricex,
                         volume: params[:product][:volume])
        format.html { redirect_to product_manage_path }

      else
        format.html { render 'home/products/editp', status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
  def order_manage

    @q = Order.ransack(params[:q])
    @pagy,@orders = pagy(@q.result.includes(:customer,:referrer).order(created_at: :desc).all_except('hoàn tất đơn'))
    # @pagy,@orders = pagy(Order.order(created_at: :desc).all_except('hoàn tất đơn'))
  end

  private
  def http_auth
    return true if Rails.env == "development"
    authenticate_or_request_with_http_basic do |username,password|
     username == Rails.application.credentials.dig(:http_auth,:uname).to_s &&
     password == Rails.application.credentials.dig(:http_auth,:pass).to_s
  end
  end

  def product_params
    params.fetch(:product).permit(:name, :price, :volume)
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
