class ApixController < ApplicationController
  # protect_from_forgery with: :null_session
  before_action :set_prod, only: %i[ update_prod delete_prod ]

  def add_order
    @number = params[:item_length].to_s.to_i
    bb = add_ref
    @orderinfo = Order.new(payment_method: params[:payment],total: params[:total],
                           discount: params[:discount],shipping_cost: params[:shipping],
                           status: "Đơn Mới", note: params[:note], completed_at: nil,
                           customer_id: params[:customer_id],referrer_id: bb )
    @orderinfo.save
    pp = @orderinfo.id
    add_items(pp,@number)

    render json: {status: "SUCCESS", message: "Fetched all the friends successfully"}, status: :ok
  end

  def product_info
    @prod = Product.find(params[:id])
    if @prod != nil
      render json: {status: true, prod: @prod}, status: :ok
    else
      render json: {status: false , message: "Không thể lấy thông tin sản phẩm "}, status: :ok

    end
  end

  def phone_check
        @cus = Customer.find_by_phone(params[:phone])
        if @cus == nil
          render json: {status: true, message: "Có Thể Sử Dụng Điện Thoại này "}, status: :ok
        else
          render json: {status: false,customer: @cus, message: "Đã Có Người Sử Dụng"}, status: :ok
        end
  end

  def ref_phone_check
    @ref = Referrer.find_by_phone(params[:phone])
    if @ref == nil
      render json: {status: true, message: "Người Giới Thiệu Mới "}, status: :ok
    else
      render json: {status: false,ref: @ref, message: "Người Giới Thiệu Cũ"}, status: :ok
    end
  end

  def customer_check
    customer_address_params
    msg = ["Đã tạo địa chỉ thành công cho KH","Địa chỉ cũ Cho KH"]
    if @cus_id == 0
      @new_customer = Customer.new(name: @name.to_s,phone: @phone)
      @new_customer.save

      create_address(@new_customer.id)

      render json: {customer: @new_customer ,message: msg[0]}, status: :ok
    else

      @old_cus = Customer.find(@cus_id)
      if @old_address == 0
        create_address(@old_cus.id)
        render json: {customer: @old_cus ,message: msg[0]}, status: :ok
      else
        render json: {customer: @old_cus ,message: msg[1]}, status: :ok
      end

    end

  end




  #For Product

  def add_prod
    @product = Product.new(name: params[:pname],price: params[:pprice],volume: params[:pvol])
    @product.save
    render json: {prod: @product ,message: "Thêm Sản Phẩm Thành Công"}, status: :ok
  end

  def update_prod

    if @prod.update(name: params[:pname], price: params[:pprice], volume: params[:pvol])
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
      @products = Product.where("name like :keyx or volume like :keyx", keyx: kw)
      render json: {prod: @products }, status: :ok

    end

  end


  private
  #For product
  def set_prod
    @prod = Product.find(params[:id])
  end
  # end for product
  def customer_address_params
    @cus_id = params[:oldCusID].to_s.to_i
    @old_address = params[:oldAdress].to_s.to_i
    @name = params[:name].to_s
    @phone = params[:phone].to_s
    @prov = params[:province].to_s.split('-')[1]
    @dist = params[:district].to_s.split('-')[1]
    @ward = params[:ward].to_s.split('-')[1]
    @street = params[:street].to_s
  end

  def add_items(order_id,number_item)
    @items = params[:items]

    number_item.times do |i|
      @product = LineItem.new(quantity: @items.values[i][:prodQty],
                          price: @items.values[i][:prodPrice],
                          product_id: @items.values[i][:prodID],
                          order_id: order_id)
      @product.save
    end
  end

  def cus_id(custom_id)
    cust = Customer.find(custom_id)
    return  cust.id
  end

  def add_ref
    if params[:orderrefID].to_s.to_i == 0
      @ref = Referrer.new(name: params[:refname].to_s,phone: params[:refphone].to_s.to_i,banking_informations:params[:refbank])
      @ref.save
    else
      @ref = Referrer.find(params[:orderrefID].to_s.to_i)
    end
    return @ref.id
  end

  def create_address(cust_id)
    @customer_address = Address.new(province_city:@prov,district: @dist,
                                    ward: @ward,street: @street,customer_id: cust_id )
    @customer_address.save
    p @customer_address
  end

end
