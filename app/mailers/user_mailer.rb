class UserMailer < ApplicationMailer
  default from: 'notifications@furnitrackr.com'

  def price_notification
    @user    = params[:user]
    @tracker = params[:tracker]
    @url     = root_url

    mail(to: @user.email, subject: 'Furnitrackr | Price has dropped!')
  end
end
