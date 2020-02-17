# frozen_string_literal: true

class FetchPriceFromProviderService
  CURRENT_PRICE_SELECTOR = ".product-pip__price .product-pip__price__value"

  def initialize(url: '')
    @url = url
  end

  def call
    response = Faraday.get(@url)

    if response.status != 200
      raise "Couldn't get #{@url}, failed with error code #{response.status}"
    end

    page = Nokogiri::HTML(response.body)
    current_price_element = page.css(CURRENT_PRICE_SELECTOR)[0]

    unless current_price_element.nil?
      strip_price(current_price_element.content).to_f
    end
  end

  private

  def strip_price(value)
    v = value.delete('€.')
    v.gsub(',', '.')
  end
end
