require "rails_helper"

feature "User checks trackers" do
  let(:user) { create(:user) }
  let(:user_2) { create(:user) }

  context "when user does not have trackers" do
    scenario "user checks empty trackers list" do
      navigate_to_trackers_page

      expect(page.has_table?).to eq false
      expect(page).to have_content("You aren't tracking any products yet.")
    end
  end

  context "when user has trackers" do
    let!(:tracker_1) { create(:tracker, user: user, created_at: 2.days.ago) }
    let!(:tracker_2) { create(:tracker, user: user) }
    let!(:tracker_3) { create(:tracker, user: user_2) }

    scenario "user checks trackers list with its trackers" do
      navigate_to_trackers_page

      expect(page.has_table?).to eq true
      expect(page).to have_css("table tbody tr", count: 2)
      find("td", text: tracker_1.title)
      find("td", text: tracker_2.title)

      expect(page).not_to have_content(tracker_3.title)
    end

    context "when tracker has prices" do
      before do
        5.times { create(:price, product: tracker_1.product) }
      end

      scenario "users checks details for a tracker in the list" do
        navigate_to_first_tracker_in_list
        assert_common_tracker_details_page

        expect(page.has_table?).to eq true
        expect(page).to have_css("table tbody tr", count: 5)
        expect(page).to have_css("#prices-chart")
      end
    end

    context "when tracker does not have prices" do
      scenario "users checks details for a tracker in the list" do
        navigate_to_first_tracker_in_list
        assert_common_tracker_details_page

        expect(page).to have_content "No prices available yet."
      end
    end
  end
end

def navigate_to_trackers_page
  sign_in_with user.email, user.password
  navigate_navbar_to "My products"

  expect(current_path).to eq trackers_path
  expect(page).to have_content("My products")
end

def navigate_to_first_tracker_in_list
  navigate_to_trackers_page
  find(:css, "a.tracker-details", match: :first).click
end

def assert_common_tracker_details_page
  expect(current_path).to eq tracker_path(tracker_1)
  expect(page).to have_content(tracker_1.title)
  expect(page).to have_content("Price history")
end
