class Admin::HomesController < ApplicationController
  def index
    @new = Order.new_order_count
    @prepared = Order.prepared_order_count
    @shipped = Order.shipped_order_count
    @completed = Order.completed_order_count
  end
end
