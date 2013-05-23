source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :test do
  gem 'simplecov', '0.7.1'
  gem 'factory_girl_rails', '4.2.1'
  gem 'selenium-webdriver', '2.32.1'
  gem 'capybara', '2.1.0'                                 # lets Cucumber pretend to be a web browser
  #gem 'metric_fu', '4.1.3'
end

# add to end of Gemfile
group :development, :test do
  gem 'debugger', '1.6.0'                                 # use Ruby debugger
  gem 'database_cleaner', '1.0.1'                         # to clear Cucumber's test database between runs
  gem 'launchy', '2.3.0'                                  # a useful debugging aid for user stories
  gem 'better_errors', '0.8.0'
  gem 'rspec-rails', '2.13.1'
  gem 'cucumber-rails', '1.3.1', :require => false
  gem 'cucumber-rails-training-wheels', '1.0.0'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer', '0.11.4'
  gem 'uglifier', '2.1.1'
  gem 'yui-compressor', '0.9.6'
end

gem 'twitter-bootstrap-rails', '2.2.6'

# jQuery gem for javascript
gem 'jquery-rails', '2.2.1'

# PostgreSQL gem
gem 'pg', '0.15.1'
gem 'foreigner', '1.4.1'

# Devise gem
gem 'devise', '2.2.4'

# Authorizations
gem 'cancan', "1.6.10"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'
