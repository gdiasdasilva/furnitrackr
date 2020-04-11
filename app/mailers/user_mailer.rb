class UserMailer < ApplicationMailer
  def price_drop_notification
    @user    = params[:user]
    @tracker = params[:tracker]

    mail(to: @user.email, subject: "Furnitrackr | Price has dropped!")
  end

  def user_contact_submission
    @message       = params[:message]
    @sender_email  = params[:email]

    mail(to: ENV["PERSONAL_EMAIL_ADDRESS"], subject: "Furnitrackr | New contact submission")
  end
end
