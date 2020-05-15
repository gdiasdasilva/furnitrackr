class UsersController < Clearance::UsersController
  def create
    @user = user_from_params
    @user.email_confirmation_token = Clearance::Token.new

    if @user.save
      UserMailer.registration_confirmation(@user).deliver_now
      redirect_to sign_in_path, flash: { success: "Please check your e-mail to confirm your account." }
    else
      render template: "users/new"
    end
  end
end
