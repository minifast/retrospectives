source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.4.4"

gem "dotenv-rails", groups: %i[development test]

gem "bootsnap", require: false
gem "pg", "~> 1.4"
gem "propshaft"
gem "puma", "~> 6.6"
gem "rails", "~> 7.1.5"

gem "devise"
gem "devise-guests"
gem "faker"
gem "geared_pagination"
gem "hashid-rails"
gem "image_processing"
gem "importmap-rails"
gem "inline_svg", github: "jamesmartin/inline_svg", ref: "e4c3d0d30f2c96a66fba264a849f8f056f6da738"
gem "nanoid"
gem "nio4r", "> 2.5.8"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "paranoia"
gem "pundit"
gem "ranked-model"
gem "solid_cable", "~> 1.0"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "view_component", "~> 2.0"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "erb_lint", require: false
  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "rubocop", "~> 1.75", require: false
  gem "rubocop-capybara", "~> 2.22", require: false
  gem "rubocop-factory_bot", "~> 2.27", require: false
  gem "rubocop-rspec", "~> 3.6", require: false
  gem "rubocop-rspec_rails", "~> 2.31", require: false
  gem "standard", "~> 1.49", require: false
  gem "standard-rails", "~> 1.3", require: false
  gem "webrick", ">= 1.8.2"
end

group :development do
  gem "annotate"
  gem "hotwire-livereload"
  gem "rack-mini-profiler"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "cuprite"
  gem "shoulda-matchers"
end

gem "solid_queue", "~> 1.2"
