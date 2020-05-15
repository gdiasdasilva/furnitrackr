require "guards/confirmed_user_guard"

Clearance.configure do |config|
  config.routes = false
  config.mailer_sender = "no-reply@furnitrackr.com"
  config.rotate_csrf_on_sign_in = true
  config.sign_in_guards = [ConfirmedUserGuard]
end
