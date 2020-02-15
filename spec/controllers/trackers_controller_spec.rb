require 'rails_helper'

RSpec.describe TrackersController do
  let(:user) { create(:user) }

  before do
    sign_in_as(user)
  end

  describe "GET index" do
    let!(:tracker_1) { create(:tracker, user: user) }
    let!(:tracker_2) { create(:tracker, user: user) }
    let!(:tracker_3) { create(:tracker) }

    it "assigns @trackers for user" do
      get :index
      expect(Tracker.count).to eq 3
      expect(assigns(:trackers)).to match_array [tracker_1, tracker_2]
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET show" do
    let!(:tracker_1) { create(:tracker, user: user) }

    it "assigns @tracker" do
      get :show, params: { id: tracker_1.id }
      expect(assigns(:tracker)).to eq(tracker_1)
    end

    it "renders the show template" do
      get :show, params: { id: tracker_1.id }
      expect(response).to render_template("show")
    end
  end

  context 'when user is not authenticated' do
    it 'fails' do

    end
  end
end
