source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# paginate with bootstrap 4
gem 'will_paginate-bootstrap4'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# authorization
gem 'pundit'

# access to deleted records
gem 'paranoia', '~> 2.2'

# track versions
gem 'paper_trail'

# countries list
gem 'country_select', '~> 4.0'

# aws service
gem 'aws-sdk-s3', '~> 1'
gem 'fog-aws'

gem 'haml-rails'
gem 'jquery-rails'
gem 'bootstrap', '~> 4.1.0'
gem 'sprockets-rails', :require => 'sprockets/railtie'
gem 'font-awesome-sass', '~> 5.0.9'
gem 'devise'
gem 'simple_form'
gem 'rubykassa', git: 'git://github.com/Sammy3124/rubykassa.git'
gem 'carrierwave', '~> 1.0'
gem 'mini_magick'
gem 'carrierwave-i18n'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
  gem 'rubocop', '0.74.0'
  gem 'haml_lint', require: false
  gem 'rubocop-rspec'
  gem 'guard-rubocop'
  gem 'timecop', '~> 0.7'
  gem 'guard-shell', '~> 0.7'
  gem 'rspec-rails', '~> 3.8'
  gem 'rails-controller-testing'
  gem 'factory_bot_rails'
  gem 'guard-rspec'
  gem 'json_spec'
  gem 'rspec-its'
  gem 'rspec-nc'
  gem 'database_cleaner'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'better_errors', '~> 2'
  gem 'binding_of_caller'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
