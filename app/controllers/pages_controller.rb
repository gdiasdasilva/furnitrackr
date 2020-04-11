class PagesController < ApplicationController
  layout "homepage", only: [:homepage]

  def homepage; end

  def how_does_it_work; end

  def contact_us; end

  def send_contact
    if submit_message?
      UserMailer.with(message: params[:message], email: params[:email]).
        user_contact_submission.deliver_now

      flash_message = { success: "Your message was successfully submitted." }
    else
      flash_message = { error: "Could not submit your message. Please try again later." }
    end

    redirect_to contact_us_path, flash: flash_message
  end

  private

  def submit_message?
    params[:message].present? && params[:email].present?
  end
end
