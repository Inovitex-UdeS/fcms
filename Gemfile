source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# PostgreSQL gem
gem 'pg'

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
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# use Haml for templates
gem 'haml'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

