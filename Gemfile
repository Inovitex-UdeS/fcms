source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :test do
  gem 'cucumber-rails'
  gem 'cucumber-rails-training-wheels'
  gem 'rspec-rails'
  gem 'simplecov'
  gem "metric_fu", "~> 4.1.3"
end

# add to end of Gemfile
group :development, :test do
  gem 'debugger'                                # use Ruby debugger
  gem 'database_cleaner'                        # to clear Cucumber's test database between runs
  gem 'capybara'                                # lets Cucumber pretend to be a web browser
  gem 'launchy'                                 # a useful debugging aid for user stories
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer'  
  gem 'uglifier', '>= 1.0.3'
  gem "twitter-bootstrap-rails"
end

# jQuery gem for javascript
gem 'jquery-rails'

# PostgreSQL gem
gem 'pg'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

