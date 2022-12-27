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
    # @addr2 = Address.where(customer_id: @customer.id).to_json
    @phone = @customer.phone
    @orders = Order.order(created_at: :desc).where(customer_id: @customer.id)
    render 'home/customer/detail'
  end
  def update_customer
    @cus = Customer.find(params[:customer][:id].to_s.to_i)
    respond_to do |format|
      if @cus.update(customer_params)
        format.html { redirect_to  customer_detail, id: @cus.id}

      else
        format.html { render 'home/customer/detail', status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_customer_addr
    @addr = Address.find(params[:address][:id].to_s.to_i)
    if params[:address][:province_city].nil? or
      params[:address][:district].nil? or params[:address][:ward].nil?
    pro = @addr.province_city
    dis = @addr.district
    war = @addr.ward
    elsif params[:address][:province_city].split('-')[1].nil? and
      params[:address][:district].split('-')[1].nil? and
      params[:address][:ward].split('-')[1].nil?
      pro = @addr.province_city
      dis = @addr.district
      war = @addr.ward
    else
      pro = params[:address][:province_city].split('-')[1]
      dis = params[:address][:district].split('-')[1]
      war = params[:address][:ward].split('-')[1]
    end
    str = params[:address][:street].empty? ? @addr.street : params[:address][:street]
    respond_to do |format|
      if @addr.update(province_city: pro, district: dis,
                ward: war, street: str)
        format.html { redirect_to  customer_detail, id: @addr.customer_id}

      else
        format.html { render 'home/customer/detail', status: :unprocessable_entity }
        format.json { render json: @addr.errors, status: :unprocessable_entity }
      end
    end
  end
  #End Customer


  #Ref
  def ref
    @q = Referrer.all.ransack(params[:q])
    @pagy,@refs = pagy(@q.result.order(created_at: :desc))
  end
  def ref_detail
    @ref = Referrer.find(params[:id])
    @phone = @ref.phone
    @orders = Order.order(created_at: :desc).where(referrer_id: @ref.id)
    render 'home/referrer/detail'
  end
  def update_ref
    @ref = Referrer.find(params[:referrer][:id].to_s.to_i)
    nam = params[:referrer][:name].empty? ? @ref.name : params[:referrer][:name]
    pho = params[:referrer][:phone].empty? ? @ref.phone : params[:referrer][:phone]
    ban = params[:referrer][:banking_informations].empty? ? @ref.banking_informations : params[:referrer][:banking_informations]
    @ref2 = Referrer.where(phone: pho)
    pho = @ref.phone if @ref2.empty? == false
    respond_to do |format|
      if @ref.update(name:nam, phone:pho,
        banking_informations:ban)
        format.html { redirect_to  ref_detail, id: @ref.id}
      else
        format.html { render 'home/referrer/detail', status: :unprocessable_entity }
        format.json { render json: @ref.errors, status: :unprocessable_entity }
      end
    end
  end
  #End Ref


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
  #end Product


  #Order
  def new_order
    product_find(0)
    @customers = Customer.all

  end

  def order_manage

    @q = Order.ransack(params[:q])
    @pagy,@orders = pagy(@q.result.includes(:customer,:referrer).order(created_at: :desc).all_except('hoàn tất đơn'))
    # @pagy,@orders = pagy(Order.order(created_at: :desc).all_except('hoàn tất đơn'))
  end
  def order_detail
    @order = Order.includes(:customer,:referrer).find(params[:id])
    @items = LineItem.includes(:product).where(order_id: @order.id)
    @subtotal = 0
    @items.each do |s|
      @subtotal = @subtotal + (s.price * s.quantity)
     end

    render 'home/order/detail'
  end

  #End Order


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
  def customer_params
    params.fetch(:customer).permit(:id,:name, :phone)
  end
  def ref_params
    params.fetch(:referrer).permit(:id,:name, :phone,:banking_informations)
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
