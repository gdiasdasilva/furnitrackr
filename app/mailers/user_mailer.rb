class UserMailer < ApplicationMailer
  default from: 'notifications@furnitrackr.com'

  def price_notification
    @user    = params[:user]
    @url     = 'http://furnitrackr.com'
    @tracker = params[:tracker]

    mail(to: @user.email, subject: 'Furnitrackr | Your price has dropped!')
  end
end
