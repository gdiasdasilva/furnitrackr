require "rails_helper"

feature "Visitor signs up" do
  scenario "with valid email and password" do
    sign_up_with "valid@example.com", "password"

    expect(current_path).to eq sign_in_path
    expect(page).to have_content("Please check your e-mail to confirm your account.")
  end

  scenario "with invalid email" do
    sign_up_with "invalid_email", "password"
    expect(page).to have_content("Log in")
  end

  scenario "with blank password" do
    sign_up_with "valid@example.com", ""
    expect(page).to have_content("Sign up")
  end
end
