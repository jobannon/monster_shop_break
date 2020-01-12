class Merchant::CouponsController < ApplicationController
  def index
    @merchant_coupons = Coupon.where(merchant_id: current_user.merchant_id) 
  end 

  def create 
    merchant = Merchant.find(current_user.merchant_id)
    merchant.coupons.create!(coupon_params)
  end

  def new
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def destroy
    Coupon.delete(params[:id])
    redirect_to merchant_coupons_path
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update
    coupon = Coupon.find(params[:id])
    coupon.update!(coupon_params)
    redirect_to merchant_coupons_path
  end

  private

    def coupon_params
      params.permit(:name, :coupon_code, :percentage_off)
    end
end 
