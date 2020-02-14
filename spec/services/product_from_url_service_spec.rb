require 'rails_helper'

RSpec.describe ProductFromUrlService do
  subject { described_class.new(url: url).call }

  context 'when URL matches an existing product' do
    let!(:product_1) { create(:product) }
    let(:url) { "http://example.com/#{product_1.provider_identifier}" }

    it 'returns the correct product instance' do
      expect(subject.id).to eq product_1.id
    end
  end

  context 'when URL does not match an existing product' do
    let(:url) { "http://example.com/abcde" }

    it 'creates a new product with the correct identifier' do
      expect { subject }.to change(Product, :count).by(1)
      expect(subject.provider_identifier).to eq 'abcde'
    end
  end

  context 'when provider identifier from URL is invalid' do
    let(:url) { "http://example.com/" }

    it 'returns nil' do
      expect(subject).to be_nil
    end
  end
end
