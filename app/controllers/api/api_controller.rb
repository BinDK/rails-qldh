class Api::ApiController < ApplicationController
  # protect_from_forgery with: :null_session
  before_action :set_prod, only: %i[ update_prod delete_prod ]
  before_action :set_order, only: %i[ find_order ]
  before_action :set_cus,  only: %i[ cus_info_update ]
  before_action :set_addr , only: %i[ cus_addr_update ]
  before_action :set_ref , only: %i[ ref_info_update ]

  before_action :customer_params, only: %i[ customer_check ]
  before_action :address_params, only: %i[ customer_check ]
  before_action :ref_params, only: %i[ add_order ]
  before_action :order_params, only: %i[ add_order ]
  before_action :product_params, only: %i[ add_prod update_prod ]

  def add_order
    @number = params[:item_length].to_s.to_i
    @uni = params[:unit].to_s.to_i
    @dis_val = params[:order][:discount_value].to_f
    final_calculate(@number, @uni, @dis_val, params[:order][:shipping_cost].to_f)

    if @number.eql? 0
      render json: {status: "MISSING", message: "Chưa Chọn Sản Phẩm"}, status: :ok
    else
      @bb = add_ref(ref_params,params[:orderrefID].to_s.to_i)
      @hold = @bb.nil? ? nil : @bb.id
      @ord = Order.new(order_params)
      @ord.status = "Mới Tạo"
      @ord.completed_at = nil
      @ord.referrer_id = @hold
      @ord.discount_unit = @uni
      @ord.total = @total
      @ord.save
      add_items(@ord.id,@number)

      render json: { status: "SUCCESS", id: @ord.id, message: "Tạo Đơn Hàng THành Công" }, status: :ok
    end
  end

  def product_info
    @prod = Product.find(params[:id])
    if @prod != nil
      render json: {status: true, prod: @prod}, status: :ok
    else
      render json: {status: false , message: "Không thể lấy thông tin sản phẩm "}, status: :ok

    end
  end
  #Check accurate price for line_item in new_order
  def phone_check
        @cus = Customer.find_by_phone(params[:phone])
        if @cus == nil
          render json: {status: true,
                        message: "Có Thể Sử Dụng Điện Thoại này "}, status: :ok
        else
          render json: {status: false,
                        customer: @cus, message: "Đã Có Người Sử Dụng"}, status: :ok
        end
  end
  def ref_phone_check
    @ref = Referrer.find_by_phone(params[:phone])
    if @ref == nil
      render json: {status: true,
                    message: "Người Giới Thiệu Mới "}, status: :ok
    else
      render json: {status: false,
                    ref: @ref, message: "Người Giới Thiệu Cũ"}, status: :ok
    end
  end

  def customer_check
    @cus_id = params[:oldCusID].to_s.to_i
    @old_address = params[:oldAdress].to_s.to_i

    msg = ["Đã tạo địa chỉ thành công cho KH","Địa chỉ cũ Cho KH"]
    if @cus_id.eql? 0
      @new_customer = Customer.new(customer_params)
      if @new_customer.save
        if create_address(address_params,@new_customer.id) == true
      render json: {customer: @new_customer,
                    address: @customer_address ,
                    message: msg[0]}, status: :ok
        else
          render json: {missing_msg: 'Thiếu Địa Chỉ Cho KH '}, status: :expectation_failed
          end
      else
        render json: {missing_msg: 'Thiếu Một Vài Thông Tin KH'}, status: :unprocessable_entity
      end

    else
      @old_cus = Customer.find(@cus_id)
      if @old_address.eql? 0
        create_address(address_params,@old_cus.id)
        render json: {customer: @old_cus,
                      address: @customer_address,
                      message: msg[0]}, status: :ok
      else
        render json: {customer: @old_cus ,
                      message: msg[1]}, status: :ok
      end
    end
  end
  def customer_address
    @addr = Address.where(customer_id: params[:id])
    render json: {addrs: @addr }, status: :ok
  end
  #For Product
  def add_prod
    @product = Product.new(product_params)
    puts @product.price
    @product.save
    render json: {prod: @product ,
                  message: "Thêm Sản Phẩm Thành Công"}, status: :ok
  end
  def update_prod
    if @prod.update(product_params)
      render json: {prod: @prod ,message: "Cập Nhật Thành Công"},status: :ok
    else
      render json: {message: "Cập Nhật Không Thành Công"}, status: :unprocessable_entity
    end
  end
  def delete_prod
    @prod.destroy
    render json: {message: "Xóa Thành Công"},status: :ok
  end
  def find_prod
    choice = params[:choice].to_s.to_i
    if  choice == 3
      @product = Product.find(params[:id])
      render json: {prod: @product }, status: :ok
    elsif choice == 0
      @products = Product.all.order(:created_at)
      render json: {prod: @products }
    else
      kw = "%#{Product.sanitize_sql_like(params[:kw])}%"
      @products = Product.where("lower(name) like :keyx or lower(volume) like :keyx", keyx: kw.downcase)
      render json: {prod: @products }, status: :ok
    end
  end
  #End for product

  #For order
  def find_order
    @prodx = []
    @pol = @order.line_items
    @pol.each do |xx|
      @prodx << LineItem.joins(:product).select('line_items.*','products.name').where(:line_items => {:order_id => @order.id}).where(:products => {:id => xx.product_id })
    end
    render json: {order: @order,cus: @order.customer,
                  items: @prodx,ref: @order.referrer }, status: :ok
  end
  def change_order_stat
    @o = Order.find(params[:id].to_s.to_i)
    if(params[:order_status].to_s == 'Hủy')
      LineItem.delete_by(order_id: params[:id].to_s.to_i)
      Order.delete(params[:id].to_s.to_i)
      render json: {msg: 'Đã Xóa Đơn Hàng Này'}, status: :ok
    else
      if(params[:order_status].to_s == 'Hoàn Tất Đơn')
        @o.update(status: params[:order_status].to_s, completed_at: Time.new)
      else
      @o.update(status: params[:order_status].to_s)
      end
      render json: {order: @o}, status: :ok
    end
  end
  def find_order_by_stat
    stat = ["Mới Tạo","Sẵn Sàng Giao","Giao Thành Công","Hoàn Tất Đơn"]
    choice = params[:choice].to_s.to_i
    @orders
    if(choice == 0)
      @orders = Order.joins(:customer,:referrer).select('orders.*, customers.name,customers.phone,referrers.name as refname').order(created_at: :desc).all_except('hoàn tất đơn')
      @orders += Order.joins(:customer).select('orders.*, customers.name,customers.phone').order(created_at: :desc).where(referrer_id: nil).all_except('hoàn tất đơn')
      @a = @orders.sort_by &:created_at

      render json: {orders: @a}, status: :ok

    else
      ks = stat[choice - 1].to_s.downcase
      @orders = Order.joins(:customer,:referrer).order(created_at: :desc)
                     .select('orders.*, customers.name,customers.phone,referrers.name as refname')
                     .where('lower(status) = :key', key: ks)
      @orders += Order.joins(:customer).select('orders.*, customers.name,customers.phone').order(created_at: :desc).where('lower(status) = :key', key: ks).where(referrer_id: nil)

      @p = @orders.sort_by &:created_at
      render json: {orders: @p}, status: :ok

    end
  end
  def find_oder_kw
    choice = params[:choice].to_s.to_i
    if(choice == 0)
      @orders = Order.joins(:customer,:referrer).select('orders.*, customers.name,customers.phone,referrers.name as refname').order(created_at: :desc).all_except('hoàn tất đơn')
      @orders += Order.joins(:customer).select('orders.*, customers.name,customers.phone').order(created_at: :desc).where(referrer_id: nil).all_except('hoàn tất đơn')
      @a = @orders.sort_by &:created_at

      render json: {orders: @a}, status: :ok
    else

    ks = params[:kw].to_s.downcase
    @p = Order.joins(:customer).select('orders.*, customers.name,customers.phone').where('customers.name like ? or customers.phone like ?',"%User C%","%user%")

    # @orders = Order.joins(:customer,:referrer).order(created_at: :desc)
    #                .select('orders.*, customers.name,customers.phone,referrers.name as refname')
    #                .where('lower(orders.customers.name) like :key or lower(orders.customers.phone) or lower(orders.referrers.name) like :key', key: ks)
    # @orders += Order.joins(:customer).select('orders.*, customers.name,customers.phone')
    #                 .order(created_at: :desc)
    #                 .where('lower(orders.customers.name) like :key or lower(orders.customers.phone)', key: ks).where(referrer_id: nil)

    # @p = @orders.sort_by &:created_at
    render json: {orders: @p}, status: :ok
    end
  end


  #end for order


  #Customer & ref search
  def cus_search
    choice = params[:choice].to_s.to_i

    if choice.eql? 0
    @cuss = Customer.all
    render json: {cus: @cuss }, status: :ok

    elsif choice.eql?3
      @cus = Customer.find(params[:id])
      @orders= Order.order(created_at: :desc).where(customer_id: @cus.id)
      @addrs = Address.where(customer_id: @cus.id)
      render json: {cus: @cus, orders: @orders,address: @addrs}, status: :ok
    else
      kw = "%#{Customer.sanitize_sql_like(params[:kw])}%"

      @cuss = Customer.where("lower(name) like :keyx or lower(phone) like :keyx",
                                 keyx: kw.downcase)
      render json: {cus: @cuss }, status: :ok
    end
  end

  def cus_name_search
    kw = "%#{Customer.sanitize_sql_like(params[:term])}%"
    @c = Customer.where("lower(name) like :keyx or lower(phone) like :keyx", keyx: kw.downcase).select(:id,:name,:phone)
    render json: {cus: @c }, status: :ok

  end
  def cus_info_update
    if @cus.update(customer_params)
      render json: {statusx: true }, status: :ok
    else
      render json: {statusx: false }, status: :unprocessable_entity
    end
  end
  def cus_addr_update
    @addr.update(address_params)
      render json: {statusx: true }, status: :ok
  end

  def ref_search
    choice = params[:choice].to_s.to_i

    if choice.eql? 0
      @refs = Referrer.all
      render json: {ref: @refs }, status: :ok

    elsif choice.eql?3
      @ref = Referrer.find(params[:id])
      @orders= Order.order(created_at: :desc).where(referrer_id: @ref.id)
      render json: {ref: @ref, orders: @orders}, status: :ok
    else
      kw = "%#{Referrer.sanitize_sql_like(params[:kw])}%"

      @refs = Referrer.where("lower(name) like :keyx or lower(phone) like :keyx",
                             keyx: kw.downcase)
      render json: {ref: @refs }, status: :ok
    end
  end

  def ref_name_search
    kw = "%#{Referrer.sanitize_sql_like(params[:term])}%"
    @r = Referrer.where("lower(name) like :keyx or lower(phone) like :keyx", keyx: kw.downcase).select(:id,:name,:phone,:banking_informations)
    render json: {ref: @r }, status: :ok

  end
  def ref_info_update
    if @ref.update(ref_params)
      render json: {statusx: true }, status: :ok
    else
      render json: {statusx: false }, status: :unprocessable_entity
    end
  end
  private
  #Model param
  def customer_params
    params.fetch(:customer,{}).permit(:name, :phone)
  end
  def address_params
    params.fetch(:address,{}).permit(
      :province_city, :district,
      :ward, :street)
  end
  def order_params
    params.fetch(:order,{}).permit(
      :payment_method, :total, :discount_value, :shipping_cost,
      :note, :customer_id, :address_info)
  end
  def ref_params
    params.fetch(:referrer,{}).permit(
      :name, :phone,
      :banking_informations)
  end
  def product_params
    params.fetch(:product,{}).permit(:name, :price, :volume)
  end

  #end model param

  #For product
  def set_prod
    @prod = Product.find(params[:id])
  end
  # end for product

  #For order
  def set_order
    @order = Order.includes(:customer,:referrer,:line_items).find(params[:orderID])
  end
  # end for order

  def final_calculate(number_item,uni,dis_val,shipping_cost)
    @items = params[:items]
    @total = 0
    number_item.times do |i|
      @total = @total + ( @items.values[i][:prodQty].to_i * @items.values[i][:prodPrice].to_f)
    end
    if uni.eql? 1
      @total = @total - ((@total * dis_val)/100) + shipping_cost
    elsif uni.eql? 2
      @total = @total -  dis_val + shipping_cost
    else
      @total = @total + shipping_cost
    end
  end
  def add_items(order_id,number_item)
    @items = params[:items]
    number_item.times do |i|
      @product = LineItem.new(quantity: @items.values[i][:prodQty],
                          price:        @items.values[i][:prodPrice],
                          product_id:   @items.values[i][:prodID],
                          order_id: order_id)
      @product.save

    end
  end

  def cus_id(custom_id)
    cust = Customer.find(custom_id)
    return  cust.id
  end

  def add_ref(param, order_ref_id)
    @ref = Referrer.new(param)
    if @ref.name.empty? and @ref.phone.empty? and @ref.banking_informations.empty? and  order_ref_id== 0
      @ref = nil
    elsif order_ref_id == 0
      @ref.save
    else
      @ref = Referrer.find(order_ref_id)
    end
    return @ref
  end

  def create_address(paramx,cust_id)
    @customer_address = Address.new(paramx)
    @customer_address.customer_id = cust_id
    if @customer_address.save
      return true
    else
      return false
    end
  end

  def set_cus
    @cus = Customer.find(params[:idCus].to_s.to_i)
  end
  def set_addr
    @addr = Address.find(params[:addressID].to_s.to_i)
  end
  def set_ref
    @ref = Referrer.find(params[:idRef].to_s.to_i)
  end

end
