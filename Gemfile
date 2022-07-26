source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'dotenv-rails', groups: [:development, :test]

gem 'bootsnap', require: false
gem 'pg', '~> 1.1'
gem 'propshaft'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.3'
gem 'redis', '~> 4.0'

gem 'devise'
gem 'hotwire-livereload', '~> 1.2'
gem 'image_processing', '~> 1.2'
gem 'importmap-rails'
gem 'inline_svg', github: 'jamesmartin/inline_svg', ref: 'e4c3d0d30f2c96a66fba264a849f8f056f6da738'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'paranoia'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'view_component'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'erb_lint', require: false
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pronto', require: false, group: :pronto
  gem 'pronto-rubocop', require: false, group: :pronto
  gem 'pronto-erb_lint', github: 'tleish/pronto-erb_lint', ref: '4b49373451b3ff26cbdec0c85d130463838d7ae7', require: false, group: :pronto
  gem 'rspec-rails'
  gem 'rubocop-performance', require: false, group: :pronto
  gem 'rubocop-i18n', require: false, group: :pronto
  gem 'rubocop-rails', require: false, group: :pronto
  gem 'rubocop-rspec', require: false, group: :pronto
  gem 'standard', group: :pronto
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
