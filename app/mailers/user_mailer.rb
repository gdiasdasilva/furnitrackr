class UserMailer < ApplicationMailer
  def price_drop_notification
    @user    = params[:user]
    @tracker = params[:tracker]

    mail(to: @user.email, subject: "Furnitrackr | Price has dropped!")
  end

  def user_contact_submission(message, email)
    @message       = message
    @sender_email  = email

    mail(to: ENV["PERSONAL_EMAIL_ADDRESS"], subject: "Furnitrackr | New contact submission")
  end

  def registration_confirmation(user)
    @user = user
    mail(to: @user.email, subject: "Furnitrackr | Please confirm your e-mail")
  end
end
