require 'hotwire/jasmine/suite_finder'

module Hotwire
  module Jasmine
    class Suite
      attr_reader :path

      def initialize(path:)
        @path = path
      end

      def id
        path.dirname.join(basename).to_s
      end

      def to_h
        {id => "/#{path}"}
      end

      def done?
        data['done']
      end

      def data
        Rails.application.config.hotwire_jasmine_store.fetch(id) { cache_defaults }
      end

      def jasmine_started(result)
        Rails.application.config.hotwire_jasmine_store.delete(id)
        suite = data
        suite['totalSpecsDefined'] = result['totalSpecsDefined']
        Rails.application.config.hotwire_jasmine_store.write(id, suite)
      end

      def jasmine_suite_started(_)
      end

      def jasmine_spec_started(_)
      end

      def jasmine_spec_done(result, *args)
        suite = data
        suite[result['status']] ||= []
        suite[result['status']].push(result)
        Rails.application.config.hotwire_jasmine_store.write(id, suite)
      end

      def jasmine_suite_done(_)
      end

      def jasmine_done(_)
        suite = Rails.application.config.hotwire_jasmine_store.fetch(id) { {'done' => false} }
        Rails.application.config.hotwire_jasmine_store.write(id, suite.merge('done' => true))
      end

      private

      def cache_defaults
        {'done' => false, 'totalSpecsDefined' => 0}
      end

      def basename
        return path.basename('.js') if path.extname.eql?('.js')

        path.basename
      end
    end
  end
end
