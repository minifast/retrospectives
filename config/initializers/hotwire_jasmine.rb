require 'hotwire/jasmine'

Hotwire::Jasmine.configure do |config|
  config.paths << Rails.root.join('spec/javascript')
end

Rails.application.config.hotwire_jasmine_store = ActiveSupport::Cache.lookup_store(:file_store, Rails.root.join('tmp/hotwire/stimulus'))
