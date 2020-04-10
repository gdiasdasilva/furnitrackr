require "rails_helper"

RSpec.describe NotifyUsersService do
  let(:tracker_1) { create(:tracker) }
  let(:tracker_2) { create(:tracker) }

  subject { described_class.call }

  before do
    allow(Tracker).to receive(:to_notify).and_return([tracker_1, tracker_2])
  end

  context "when there are users to notify" do
    it "sends emails to users" do
      double_mailer = double("user mailer")

      expect(UserMailer).to receive(:with).with(user: tracker_1.user, tracker: tracker_1).
        and_return(double_mailer)
      expect(UserMailer).to receive(:with).with(user: tracker_2.user, tracker: tracker_2).
        and_return(double_mailer)

      double_mailer.should_receive(:price_drop_notification).exactly(2).times.
        and_return(double_mailer)

      double_mailer.should_receive(:deliver_now).exactly(2).times

      subject
    end
  end
end
