class HomeController < ApplicationController
  def index

  end

  def new_order
    product_find(0)

  end

  def product_manage
    product_find(0)

  end

  private


  # 0 to find all
  # other number to find specific product
  def product_find(desire)
    if desire == 0
      @products = Product.all
    else
      @products = Product.find(desire)
    end
    @products
  end
end
