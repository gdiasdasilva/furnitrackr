require "rails_helper"

feature "User logs in" do
  before do
    create(:user, email: "valid@example.com", password: "password")
  end

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
end
