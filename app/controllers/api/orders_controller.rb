class Api::OrdersController < ApplicationController
  before_action :set_order, only: %i[ find_order ]
  before_action :order_params, only: %i[ add_order ]

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
    if params[:order_status].to_s == 'Hủy'
      LineItem.delete_by(order_id: params[:id].to_s.to_i)
      Order.delete(params[:id].to_s.to_i)
      render json: {msg: 'Đã Xóa Đơn Hàng Này'}, status: :ok
    else
      if params[:order_status].to_s == 'Hoàn Tất Đơn'
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
    if choice == 0
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


  private


  def order_params
    params.fetch(:order,{}).permit(
      :payment_method, :total, :discount_value, :shipping_cost,
      :note, :customer_id, :address_info)
  end
  def set_order
    @order = Order.includes(:customer,:referrer,:line_items).find(params[:orderID])
  end

end
