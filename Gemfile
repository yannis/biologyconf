source 'https://rubygems.org'

gem 'rails', '4.0.0'
gem 'mysql2'

gem 'haml-rails'
gem 'html5-rails'
# gem "devise"
# gem "devise-encryptable"
# gem "cancan", '1.6.9'
# gem "hpricot"
# gem "ruby_parser"
# gem 'icalendar'
gem 'paperclip'
# gem "bio", '~>1.4.3'
# gem "calendar_date_select"
# gem 'htmlentities'
# # gem 'will_paginate', '~>3.0.2'
# gem "kaminari"
# gem "calendar_helper"
gem 'airbrake'
# gem "newrelic_rpm"
gem 'bundler'

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails', '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem "jquery-ui-rails"
gem 'uglifier', '>= 1.0.3'

gem 'devise',              github: 'plataformatec/devise'
gem 'responders',          github: 'plataformatec/responders'
gem 'inherited_resources', github: 'josevalim/inherited_resources'
# gem 'ransack',             github: 'ernie/ransack', branch: 'rails-4'
gem 'activeadmin',         github: 'gregbell/active_admin', branch: 'rails4'
gem 'formtastic',          github: 'justinfrench/formtastic'
gem 'countries'
gem 'country_select'
gem 'prawn'

group :development do
  gem "capistrano"
  gem "guard-livereload"
  gem 'guard-zeus'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'rb-inotify', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-fchange', require: false
  gem 'quiet_assets'
  gem "better_errors"
  gem "binding_of_caller"
  gem "rspec-rails"
end

group :test do
  gem "rspec-instafail"
  gem "launchy"
  gem "database_cleaner"
  gem "faker"
  gem 'timecop'
  gem 'email_spec'
  gem "factory_girl_rails"
  gem "selenium-webdriver"
  gem 'shoulda-matchers'
  gem "faker"
  gem 'capybara-screenshot'# , :require => false
  gem 'simplecov', :require => false
end

group :production do
  gem 'god'
  gem "unicorn"
end
