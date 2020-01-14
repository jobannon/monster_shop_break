class Merchant::CouponsController < Merchant::BaseController
  def index
    @merchant_coupons = Coupon.where(merchant_id: current_user.merchant_id)
  end 

  def create 
    merchant = Merchant.find(current_user.merchant_id)
    merchant.coupons.create(coupon_params)
    redirect_to merchant_coupons_path 
  end

  def new
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def destroy
    # if used on an order... then 
    # flash[:notice] = Cannot delete this as it has been used on an order
    # else (delete this)
      Coupon.delete(params[:id])
    # end
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
