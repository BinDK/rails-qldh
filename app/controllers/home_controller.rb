class HomeController < ApplicationController
  include Pagy::Backend
  def index

  end

  def new_order
    product_find(0)
    @customers = Customer.all
  end

  def product_manage
    # product_find(0)
    # @entries = 3
    # @pages = Product.pages(@entries)
    @pagy,@products = pagy(Product.all)

  end

  def order_manage
    @entries = 3
    # @pages = Order.pages(@entries)
    @pagy,@orders = pagy(Order.order(created_at: :desc).all)


  end

  private


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
