class HomeController < ApplicationController
  def index

  end

  def new_order
    product_find(0)
    @customers = Customer.all
  end

  def product_manage
    # product_find(0)
    @entries = 3
    @pages = Product.pages(@entries)
    @products = Product.all.limit(@entries)

  end

  def order_manage
    @entries = 3
    @pages = Order.pages(@entries)
    @orders = Order.order(created_at: :desc).all.limit(@entries)

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
