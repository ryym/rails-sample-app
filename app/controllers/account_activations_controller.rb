class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if should_activate? user, params[:id]
      user.activate
      log_in user
      flash[:success] = 'Account activated!'
      redirect_to user
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to root_url
    end
  end

  private
    def should_activate?(user, token)
      user && ! user.activated? && user.authenticated?(:activation, token)
    end
end
