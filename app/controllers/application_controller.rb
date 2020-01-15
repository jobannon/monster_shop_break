class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :cart, :current_user, :user_redirect, :coupon

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_redirect(user)
    if user.admin?
      redirect_to '/admin/dashboard'
    elsif user.merchant?
      redirect_to '/merchant/dashboard'
    else
      redirect_to '/profile'
   end
  end

  def coupon 
    if session[:coupon] 
      @coupon ||= Coupon.find(session[:coupon].first["id"])
    else
      @coupon ||= String.new
    end
  end
end
