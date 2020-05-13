require "rails_helper"

feature "User logs in" do
  let!(:user) { create(:user, email: "valid@example.com", password: "password") }

  scenario "with valid email and password" do
    sign_in_with "valid@example.com", "password"
    expect(page).to have_button("Sign out")
  end

  scenario "with invalid email" do
    sign_in_with "invalid_email", "password"
    expect(page).to have_content("Log in")
  end

  scenario "with blank password" do
    sign_in_with "valid@example.com", ""
    expect(page).to have_content("Log in")
  end

  scenario "unconfirmed user" do
    user.update(email_confirmed_at: nil)

    sign_in_with "valid@example.com", "password"
    expect(page).to have_content "Please check your e-mail to confirm your account."
  end
end
