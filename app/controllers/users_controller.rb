class UsersController < Clearance::UsersController
  def create
    @user = user_from_params
    @user.email_confirmation_token = Clearance::Token.new

    if @user.save
      UserMailer.registration_confirmation(@user).deliver_now
      redirect_back_or url_after_create
    else
      render template: "users/new"
    end
  end
end
