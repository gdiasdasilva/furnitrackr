# frozen_string_literal: true

desc "Check if price is found with CSS selector currently set up"
task price_selector_sanity_check: :environment do
  p = FetchPriceFromProviderService.new(
    url: "https://www.ikea.com/pt/pt/p/billy-estante-branco-50263838/"
  ).call

  if p.blank?
    Bugsnag.notify("Selector sanity check error. Couldn't fetch price with current selector.")
  end
end
