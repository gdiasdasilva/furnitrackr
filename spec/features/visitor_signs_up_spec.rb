require "rails_helper"

feature "Visitor signs up" do
  scenario "with valid email and password" do
    sign_up_with "valid@example.com", "password"

    expect(current_path).to eq sign_in_path
    expect(page).to have_content("Please check your e-mail to confirm your account.")
  end

  scenario "Visitor signs up, tries to sign in, confirms email and signs out" do
    sign_up_with "valid@example.com", "password"
    sign_in_with "valid@example.com", "password"

    expect(page).to have_content "Please check your e-mail to confirm your account."

    open_email "valid@example.com"
    click_first_link_in_email

    expect(page).to have_content "Your e-mail was confirmed. You're all set!"

    click_button "Sign out"
    expect(current_path).to eq(sign_in_path)
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
