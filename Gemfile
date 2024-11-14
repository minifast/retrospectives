source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.6'

gem 'dotenv-rails', groups: [:development, :test]

gem 'bootsnap', require: false
gem 'pg', '~> 1.4'
gem 'propshaft'
gem 'puma', '~> 6.0'
gem 'rails', '~> 7.0.8'
gem 'redis', '~> 5.0'

gem 'devise'
gem 'devise-guests'
gem 'faker'
gem 'geared_pagination', '~> 1.1'
gem 'image_processing', '~> 1.2'
gem 'importmap-rails'
gem 'inline_svg', github: 'jamesmartin/inline_svg', ref: 'e4c3d0d30f2c96a66fba264a849f8f056f6da738'
gem 'hashid-rails'
gem 'nanoid'
gem 'nio4r', '> 2.5.8'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'paranoia'
gem 'pundit', '~> 2.2'
gem 'ranked-model'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'view_component', '~> 2.83'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'erb_lint', require: false
  gem 'factory_bot_rails'
  gem 'pronto', require: false, group: :pronto
  gem 'pronto-rubocop', '~> 0.11.5', require: false, group: :pronto
  gem 'pronto-erb_lint', github: 'tleish/pronto-erb_lint', ref: '4b49373451b3ff26cbdec0c85d130463838d7ae7', require: false, group: :pronto
  gem 'rspec-rails'
  gem 'rubocop-performance', require: false, group: :pronto
  gem 'rubocop-i18n', require: false, group: :pronto
  gem 'rubocop-rails', require: false, group: :pronto
  gem 'rubocop-rspec', '~> 3.2', require: false, group: :pronto
  gem 'standard', '~> 1.42', group: :pronto
  gem 'webrick', '>= 1.8.2'
end

group :development do
  gem 'annotate'
  gem 'hotwire-livereload', '~> 1.2'
  gem 'pivotal_git_scripts'
  gem 'rack-mini-profiler'
  gem 'web-console'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'cuprite'
  gem 'shoulda-matchers', '~> 5.2'
end
