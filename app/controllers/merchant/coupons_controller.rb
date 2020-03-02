class Merchant::CouponsController < Merchant::BaseController
  def index
    @merchant_coupons = Coupon.where(merchant_id: current_user.merchant_id)
  end 

  def create 
    merchant = Merchant.find(current_user.merchant_id)
    # merchant.coupons.create(coupon_params)
    added_element = merchant.coupons.new(coupon_params) # may call added coupon instead of added_element
    if added_element.save 
      flash[:notice] = "Coupon Added" 
      redirect_to merchant_coupons_path 
    else
      flash[:notice] = added_element.errors.full_messages.to_sentence + " " + "Please try again"
      redirect_to new_merchant_coupon_path
    end

  end

  def new
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def destroy
    current_coupon = Coupon.find(params[:id])
    if current_coupon.orders.count > 0 #model method for this j
      flash[:notice] = 'This coupon cannot be deleted'
    else
      Coupon.delete(params[:id])
      flash[:notice] = 'This coupon was sucessfully be deleted'
    end
    redirect_to merchant_coupons_path
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update

    coupon = Coupon.find(params[:id])
    coupon.update(coupon_params)
    redirect_to merchant_coupons_path

  end

  private

    def coupon_params
      params.permit(:name, :coupon_code, :percentage_off)
    end

end 
