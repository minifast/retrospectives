module Hotwire
  module Jasmine
    class Configuration
      include Singleton

      attr_accessor :paths

      def initialize(paths: [])
        @paths = Array(paths)
      end
    end
  end
end
