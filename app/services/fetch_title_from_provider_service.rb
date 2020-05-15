# frozen_string_literal: true

class FetchTitleFromProviderService
  def initialize(url:)
    @url = url
  end

  def call
    response = Faraday.get(@url)

    if response.status != 200
      raise "Couldn't get #{@url}, failed with error code #{response.status}"
    end

    Nokogiri::HTML(response.body).title
  end
end
