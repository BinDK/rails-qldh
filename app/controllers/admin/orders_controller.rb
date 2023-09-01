class Admin::OrdersController < ApplicationController
  before_action :set_order, only: %i[show]

  def index
    @q = Order.ransack(params[:q])
    @pagy, @orders = pagy(@q.result.includes(:customer,:referrer).order(created_at: :desc).all_except('hoàn tất đơn'))
  end

  def show
    @items = LineItem.includes(:product).where(order_id: @order.id)
    @subtotal = @items.sum { |s| (s.price * s.quantity) }
    render :show
  end

  def new
    @items = LineItem.new
    @orders = Order.new
    @customers = Customer.all
  end

  private

  def set_order
    @order = Order.includes(:customer, :referrer).find(params[:id])
  end
end
