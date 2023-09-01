class Api::OrdersController < ApplicationController
  before_action :set_order, only: %i[find_order change_order_stat]
  before_action :order_params, only: %i[add_order]

  def find_order
    @prodx = @order.line_items.joins(:product).select('line_items.*','products.name')
    render json: {order: @order, cus: @order.customer, items: @prodx, ref: @order.referrer }, status: :ok
  end

  def change_order_stat
    if params[:order_status] == 'Hủy'
      @order.line_items.delete_all
      @order.delete
      render json: { msg: 'Đã Xóa Đơn Hàng Này' }, status: :ok
    else
      @order.update(status: params[:order_status], completed_at: (params[:order_status] == 'Hoàn Tất Đơn' ? Time.new : @order.completed_at))
      render json: { order: @order }, status: :ok
    end
  end

  def find_order_by_stat
    stat = ["Mới Tạo","Sẵn Sàng Giao","Giao Thành Công","Hoàn Tất Đơn"]
    choice = params[:choice].to_i
    @orders = Order.joins(:customer, :referrer).select('orders.*, customers.name, customers.phone, referrers.name as refname').order(created_at: :desc)
    @orders = choice == 0 ? @orders.all_except('hoàn tất đơn') : @orders.where('lower(status) = ?', stat[choice - 1].downcase)
    render json: {orders: @orders.sort_by(&:created_at)}, status: :ok
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
      render json: {orders: @p}, status: :ok
    end
  end

  def find_oder_kw
    @orders = Order.joins(:customer,:referrer).select('orders.*, customers.name,customers.phone,referrers.name as refname').order(created_at: :desc)
    @orders = params[:choice] == 0 ? @orders.all_except('hoàn tất đơn') : @orders.where('customers.name like ? or customers.phone like ?',"%#{params[:kw].downcase}%","%#{params[:kw].downcase}%")
    render json: {orders: @orders.sort_by(&:created_at)}, status: :ok
  end

  private

  def order_params
    params.fetch(:order,{}).permit(:payment_method, :total, :discount_value, :shipping_cost, :note, :customer_id, :address_info)
  end

  def set_order
    @order = Order.includes(:customer, :referrer, :line_items).find(params[:id])
  end
end
