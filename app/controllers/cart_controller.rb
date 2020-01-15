class CartController < ApplicationController
  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    @items = cart.items unless current_user && current_user.admin?
    render 'errors/404' if current_user && current_user.admin?
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def increment_decrement
    if params[:increment_decrement] == "increment"
      cart.add_quantity(params[:item_id]) unless cart.limit_reached?(params[:item_id])
    elsif params[:increment_decrement] == "decrement"
      cart.subtract_quantity(params[:item_id])
      return remove_item if cart.quantity_zero?(params[:item_id])
    end
    redirect_to "/cart"
  end

  def apply_coupon
    if Coupon.where(coupon_code: params[:coupon_code]).count > 0 #if this exists
      this_coup = Coupon.where(coupon_code: params[:coupon_code])
      cart.items.each do |item| 
        if item.first.merchant_id == this_coup.first.merchant_id   
          session[:coupon] = Coupon.where(coupon_code: params[:coupon_code])
        end
      end
    else
      flash[:notice] = "Please Enter A Valid Coupon"
    end
    redirect_to "/cart"
  end 

end
