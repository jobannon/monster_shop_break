class Merchant::CouponsController < ApplicationController
  def index
    @merchant_coupons = Coupon.where(merchant_id: current_user.merchant_id) 
  end 

  def show
    @coupon = Coupon.find(params[:id])
  end

  def destroy
    Coupon.delete(params[:id])
    redirect_to merchant_coupons_path
  end
end 
