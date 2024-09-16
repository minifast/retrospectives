require 'hotwire/jasmine/configuration'
require 'hotwire/jasmine/suite'

module Hotwire
  module Jasmine
    def self.configuration
      Hotwire::Jasmine::Configuration.instance
    end

    def self.configure(&block)
      yield(configuration) if block
    end
  end
end
