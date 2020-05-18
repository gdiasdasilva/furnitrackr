require "rails_helper"

feature "User submits a contact message" do
  let(:user) { create(:user) }

  before do
    visit root_path
    navigate_navbar_to "Contact us"
  end

  scenario "with valid data for" do
    fill_in "Your e-mail address", with: "example@furnitrackr.com"
    fill_in "Message", with: "This is my example message."
    fill_in "How much is 10 minus 5?", with: "5"
    click_button "Send"

    expect(page).to have_content "Your message was successfully submitted."
  end

  scenario "with wrong spam detection answer" do
    fill_in "Your e-mail address", with: "example@furnitrackr.com"
    fill_in "Message", with: "This is my example message."
    fill_in "How much is 10 minus 5?", with: "6"
    click_button "Send"

    expect(page).to have_content "Gotcha."
  end
end
