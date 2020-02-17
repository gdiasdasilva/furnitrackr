require 'rails_helper'

RSpec.describe FetchPriceFromProviderService do
  TEST_URL = 'http://example.com'.freeze

  describe '#call' do
    subject { described_class.new(url: TEST_URL).call }

    context 'when API call returns status code different from 200' do
      let!(:stub) { stub_request(:get, TEST_URL).to_return(status: 404) }

      it 'returns an error message' do
        expect { subject }.to(
          raise_error("Couldn't get http://example.com, failed with error code 404"),
        )
        assert_requested stub
      end
    end

    context 'when API returns unexpected HTML' do
      let!(:stub) do
        stub_request(:get, TEST_URL).
          to_return(status: 200, body: '<html><span>10,99€</span></html>')
      end

      it 'returns nil' do
        expect(subject).to eq nil
        assert_requested stub
      end
    end

    context 'when API call returns expected HTML' do
      context 'when price includes decimals separated with comma' do
        let!(:stub) do
          stub_request(:get, TEST_URL).
            to_return(status: 200, body: '<html><span class="product-pip__price">'\
              '<span class="product-pip__price__value">10,99€</span></span></html>')
        end

        it 'parses it correctly' do
          expect(subject).to eq 10.99
          assert_requested stub
        end
      end

      context 'when price includes thousands separated with dot' do
        let!(:stub) do
          stub_request(:get, TEST_URL).
            to_return(status: 200, body: '<html><span class="product-pip__price">'\
              '<span class="product-pip__price__value">1.099,99€</span></span></html>')
        end

        it 'parses it correctly' do
          expect(subject).to eq 1099.99
          assert_requested stub
        end
      end
    end
  end
end
