require "rails_helper"

feature "User creates a tracker" do
  let(:user) { create(:user) }

  before do
    allow_any_instance_of(Tracker).to receive(:fetch_current_price).and_return(200)
  end

  scenario "user creates a tracker" do
    sign_in_with user.email, user.password

    navigate_navbar_to "Track new product"

    expect(page).to have_content("Track a new product")

    fill_tracker_form
    click_button "Submit"

    expect(current_path).to eq tracker_path(Tracker.last)
    expect(page).to have_content("My Amazing Product")
    expect(page).to have_content("Tracker was successfully created.")
  end
end

def fill_tracker_form
  fill_in "Tracker name", with: "My Amazing Product"
  fill_in "Product URL", with: "http://example-url.com/incredible-product"
  fill_in "Threshold price (€)", with: "250"
end
