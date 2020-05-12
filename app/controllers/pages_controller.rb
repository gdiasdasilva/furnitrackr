class PagesController < ApplicationController
  layout "homepage", only: [:homepage]
  before_action :detect_spam, only: [:send_contact]

  SPAM_MATH_SOLUTION = 5

  def homepage; end

  def how_does_it_work; end

  def contact_us; end

  def send_contact
    if submit_message?
      UserMailer.user_contact_submission(params[:message], params[:email]).deliver_now
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

  def detect_spam
    return if params[:math].to_i == SPAM_MATH_SOLUTION

    redirect_to contact_us_path, flash: { warning: "Gotcha." }
  end
end
