class Admin::ReferrersController < ApplicationController
  def index
    @q = Referrer.all.ransack(params[:q])
    @pagy, @refs = pagy(@q.result.order(created_at: :desc))
  end

  def show
    @ref = Referrer.find(params[:id])
    @phone = @ref.phone
    @orders = Order.order(created_at: :desc).where(referrer_id: @ref.id)
  end

  def update
    @ref = Referrer.find(params[:id])
    # nam = params[:referrer][:name].empty? ? @ref.name : params[:referrer][:name]
    # pho = params[:referrer][:phone].empty? ? @ref.phone : params[:referrer][:phone]
    # ban = params[:referrer][:banking_informations].empty? ? @ref.banking_informations : params[:referrer][:banking_informations]
    # @ref2 = Referrer.where(phone: pho)
    # pho = @ref.phone if @ref2.empty? == false

    if @ref.update(ref_params)
      redirect_to admin_referrer_path(@ref)
    else
      flash[:alert] = 'Failed to create ref.'
      redirect_to admin_referrer_path(@ref), status: :unprocessable_entity
    end
  end

  private

  def ref_params
    params.fetch(:referrer).permit(:name, :phone, :banking_informations)
  end
end
