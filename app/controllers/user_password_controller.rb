class UserPasswordController < ApplicationController
  def edit
    @user = User.find(current_user.id) if current_user
    render '/errors/404' unless current_user
  end

  def update
    if current_user.authenticate(params[:current_password])
      current_user.password = params[:new_password]
      current_user.password_confirmation = params[:confirm_new_password]
      if current_user.save
        user_redirect(current_user)
        flash[:happy] = 'Password updated successfully'
      else
        flash[:sad] = "Passwords don't match"
        render :edit
      end
    else
      flash[:sad] = 'Incorrect password, please try again'
      render :edit
    end
  end
end
