# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

###### BASIC FRAMEWORKS ######
# Rails web framework.
gem "rails", "~> 7.0.8"
# Postgres database adapter.
gem "pg", "~> 1.1"
# Web server.
gem "puma", "~> 5.0"


##### VIEWS/CONTROLLERS #####
# Generates JSON structures via a builder interface.
gem "jbuilder"
# Pagination of models for use in views.
gem "kaminari"
# Get file from MinIO Bucket url
gem "open-uri"

##### ADDITIONAL FUNCTIONS #####
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
# Simple, efficient background processing for Ruby
gem "sidekiq"
# Redis adapter (a memmory database for sidekiq) 
gem "redis"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# This 'if' may seem redundant but for some reason it is necessary to suppress
# a warning on non (Windows or JRuby) platforms.
if %w(mingw mswin x64_mingw jruby).include?(RUBY_PLATFORM)
  gem "tzinfo-data", platforms: %i(mingw mswin x64_mingw jruby)
end

group :development, :test do
  # Show database columns and indexes inside files.
  gem "annotate"
  ### TO-DO: include brakeman and a workflow for it
  # # Scan for vulnerabilities and other static analysis.
  # gem "brakeman"

  # Library for stubbing and setting expectations on HTTP requests
  gem "webmock"
  # Ensure the database is in a clean state on every test.
  gem "database_cleaner-active_record", "~> 2.1"
  # Generate fake data for use in tests.
  gem "faker"
  # Generate models based on factory definitions.
  gem "factory_bot_rails"
  ### TO-DO: In addition to the foreman gem, create a bin/setup script to prepare
  ### the project for first use. Use as reference:
  ### https://github.com/rubyforgood/human-essentials/blob/main/bin/setup
  # Run multiple processes from a Procfile (web, jobs, etc.)
  gem "foreman"
  # Rails plugin for command line.
  gem "pry-rails"
  # RSpec behavioral testing framework for Rails.
  gem "rspec-rails", "~> 6.1.2"
  # Show code coverage.
  gem "simplecov"
  # More concise test ("should") matchers
  gem "shoulda-matchers", "~> 6.2"
  # Static analysis / linter.
  gem "rubocop"
  gem "rubocop-packaging"
  gem "rubocop-performance", "~> 1.21.0"
  gem "rubocop-rails", "~> 2.24.1"
  gem "rubocop-rspec", "~> 2.29.1"
  gem "rubycritic"
end
