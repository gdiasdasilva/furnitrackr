require "rails_helper"

feature "User logs out" do
  before do
    create(:user, email: "valid@example.com", password: "password")
    sign_in_with "valid@example.com", "password"
  end

  scenario "user logs out" do
    click_button "Sign out"
    expect(page).to have_link("Log in")
    expect(page).to have_link("Sign up")
    expect(current_path).to eq sign_in_path
  end
end
