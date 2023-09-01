class Admin::ProductsController < ApplicationController
  def index
    @q = Product.all.ransack(params[:q])
    @pagy, @products = pagy(@q.result.order(created_at: :desc))
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to admin_products_path, status: :ok
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to admin_product_path(@product), status: :ok
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def product_params
    permitted_param = params.fetch(:product).permit(:name, :price, :volume)
    permitted_param[:price] = permitted_param[:price].to_s.gsub('.', '').to_f / 1000

    permitted_param
  end
end
