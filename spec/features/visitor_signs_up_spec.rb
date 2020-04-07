require "rails_helper"

feature "Visitor signs up" do
  scenario "with valid email and password" do
    sign_up_with "valid@example.com", "password"
    expect(page).to have_button("Sign out")
  end

  scenario "with invalid email" do
    sign_up_with "invalid_email", "password"
    expect(page).to have_content("Log in")
  end

  scenario "with blank password" do
    sign_up_with "valid@example.com", ""
    expect(page).to have_content("Sign up")
  end

  def sign_up_with(email, password)
    visit sign_up_path
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Sign up"
  end
end
