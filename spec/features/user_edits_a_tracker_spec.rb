require "rails_helper"

feature "User edits a tracker" do
  let(:user) { create(:user) }
  let!(:tracker_2) { create(:tracker, user: user, title: "Some name", threshold_price: 350) }

  scenario "user edits a tracker" do
    sign_in_with user.email, user.password
    navigate_navbar_to "My products"
    find(:css, "a.tracker-edit", match: :first).click

    expect(page).to have_content("Editing Some name")

    fill_in "Tracker name", with: "My Amazing Product"
    fill_in "Threshold price (€)", with: "10"

    click_button "Submit"

    expect(current_path).to eq tracker_path(Tracker.first)
    expect(page).to have_content("My Amazing Product")
    expect(page).to have_content("You'll be notified via e-mail once the price for My Amazing Product "\
      "falls below your predefined threshold of 10.00€.")
    expect(page).to have_content("Tracker was successfully updated.")
  end
end
