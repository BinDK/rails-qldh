class Admin::CustomersController < ApplicationController
  def index
    @q = Customer.all.ransack(params[:q])
    @pagy, @customers = pagy(@q.result.order(created_at: :desc))
  end

  def show
    @customer = Customer.find(params[:id])
    @addr = Address.where(customer_id: @customer.id)
    # @addr2 = Address.where(customer_id: @customer.id).to_json
    @phone = @customer.phone
    @orders = Order.order(created_at: :desc).where(customer_id: @customer.id)
  end

  def update_customer
    @cus = Customer.find(params[:customer][:id].to_s.to_i)
    respond_to do |format|
      if @cus.update(customer_params)
        format.html { redirect_to  customer_detail, id: @cus.id}

      else
        format.html { redirect_to customer_detail, id:@cus.id, status: :unprocessable_entity }
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
end
