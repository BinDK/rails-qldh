class Api::ProductsController < ApplicationController
  before_action :set_prod, only: %i[ update_prod delete_prod ]
  before_action :product_params, only: %i[ add_prod update_prod ]


  def create
    @product = Product.new(product_params)
    puts @product.price
    @product.save
    render json: {prod: @product ,
                  message: "Thêm Sản Phẩm Thành Công"}, status: :ok
  end

  def update
    if @prod.update(product_params)
      render json: {prod: @prod ,message: "Cập Nhật Thành Công"},status: :ok
    else
      render json: {message: "Cập Nhật Không Thành Công"}, status: :unprocessable_entity
    end
  end

  def destroy
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
      @products = Product.where("lower(name) like :keyx or lower(volume) like :keyx", keyx: kw.downcase)
      render json: {prod: @products }, status: :ok
    end
  end


  private
  def product_params
    params.fetch(:product,{}).permit(:name, :price, :volume)
  end
  def set_prod
    @prod = Product.find(params[:id])
  end

end
