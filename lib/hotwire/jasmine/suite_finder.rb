module Hotwire
  module Jasmine
    class SuiteFinder
      attr_reader :paths

      def initialize(paths: [])
        @paths = Array(paths)
      end

      def self.resolve(paths: Hotwire::Jasmine.configuration.paths)
        new(paths: Array(paths)).resolve
      end

      def self.find(id)
        resolve.index_by { |suite| suite.id }.fetch(id)
      end

      def resolve
        paths
          .flat_map { |path| path.glob('**/*spec.js') }
          .map { |path| Suite.new(path: path.relative_path_from(Rails.root)) }
      end
    end
  end
end
