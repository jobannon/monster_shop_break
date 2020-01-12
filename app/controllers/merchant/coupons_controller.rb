class Merchant::CouponsController < ApplicationController
  def index
    @merchant_coupons = Coupon.where(merchant_id: current_user.merchant_id) 
  end 
end 
