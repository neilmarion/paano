source 'https://rubygems.org'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'activerecord-postgresql-adapter'
gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem "twitter-bootstrap-rails"
end

gem 'jquery-rails'
gem 'omniauth-twitter'
gem 'omniauth-facebook', '1.4.0'
gem 'omniauth-identity'
gem 'devise'
gem 'activerecord-reputation-system', require: 'reputation_system'
gem 'acts-as-taggable-on'
gem 'kaminari'
gem 'bootstrap-kaminari-views'
gem 'bootstrap_helper'
gem 'rails3-jquery-autocomplete'
gem 'paranoia'

gem 'friendly_id'



# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'debugger'

group :test, :development, :staging do
  gem 'faker'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'rb-inotify', '~> 0.9'
  gem 'better_errors'
  gem 'rack-mini-profiler'
  gem 'binding_of_caller'
end

group :test do
  gem 'webmock'
  gem 'capybara'
  gem 'factory_girl'
  gem 'guard-rspec'
  gem 'shoulda'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'simplecov'
end
