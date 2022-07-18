source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'dotenv-rails', groups: [:development, :test]

gem 'bootsnap', require: false
gem 'devise'
gem 'hotwire-livereload', '~> 1.2'
gem 'image_processing', '~> 1.2'
gem 'importmap-rails'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'pg', '~> 1.1'
gem 'propshaft'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.3'
gem 'redis', '~> 4.0'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'view_component'
gem 'inline_svg', github: 'minifast/inline_svg', branch: 'allow-propshaft-fallbacks'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'rubocop-i18n', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'standard'
end

group :development do
  gem 'annotate'
  gem 'pivotal_git_scripts'
  gem 'rack-mini-profiler'
  gem 'web-console'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'webdrivers'
end
