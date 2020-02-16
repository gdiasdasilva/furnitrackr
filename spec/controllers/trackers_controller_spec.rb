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

  describe "GET new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "POST create" do
    subject { post :create, params: { tracker: params } }
    let(:params) do
      {
        title: 'my product',
        url: 'http://example.com/aaa-bbb',
        threshold_price: 59900,
      }
    end
    let(:product) { create(:product) }

    before do
      allow(ProductFromUrlService).to receive_message_chain(:new, :call).and_return(product)
    end

    it "creates a new entry" do
      expect { subject }.to change(Tracker, :count).by(1)
      expect(Tracker.last).to have_attributes(
        title: 'my product',
        url: 'http://example.com/aaa-bbb',
        threshold_price: 59900,
        enabled: true,
        user: user,
        product: product,
      )

      expect(flash[:success]).to eq 'Tracker was successfully created.'
    end

    context 'when a valid product is not retrieved' do
      it "does not create a new entry" do
        allow(ProductFromUrlService).to receive_message_chain(:new, :call).and_return(nil)
        expect { subject }.to_not(change(Tracker, :count))
      end
    end
  end

  context 'when user is not authenticated' do
    it 'fails' do

    end
  end
end
