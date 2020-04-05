# encoding : utf-8

MoneyRails.configure do |config|
  config.default_currency = :eur
  config.rounding_mode = BigDecimal::ROUND_HALF_EVEN
end

Money.locale_backend = :i18n
