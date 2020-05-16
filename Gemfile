# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.6"

gem "bootsnap", ">= 1.4.2", require: false
gem "bugsnag"
gem "bulma-rails", "~> 0.8.0"
gem "chartkick"
gem "clearance"
gem "delayed_job_active_record"
gem "faraday", "~> 1.0.0"
gem "jbuilder", "~> 2.7"
gem "money-rails"
gem "pg"
gem "puma", "~> 3.11"
gem "rails", "6.0.3"
gem "sass-rails", "~> 5"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 4.0"

group :development, :test do
  gem "awesome_print"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "pry-byebug"
  gem "rspec-rails", "~> 4.0.0"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "email_spec"
  gem "launchy"
  gem "rails-controller-testing"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "simplecov"
  gem "webdrivers"
  gem "webmock"
end
