class EmailConfirmationsController < ApplicationController
  def update
    user = User.find_by!(email_confirmation_token: params[:token])
    user.confirm_email
    sign_in user
    redirect_to trackers_path, notice: "Your e-mail was confirmed. You're all set!"
  end
end
