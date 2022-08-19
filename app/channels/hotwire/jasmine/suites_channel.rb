module Hotwire
  module Jasmine
    class SuitesChannel < ActionCable::Channel::Base
      def jasmine_started(data)
        Hotwire::Jasmine::SuiteFinder.find(data['suiteId']).jasmine_started(data)
      end

      def jasmine_suite_started(data)
        Hotwire::Jasmine::SuiteFinder.find(data['suiteId']).jasmine_suite_started(data)
      end

      def jasmine_spec_started(data)
        Hotwire::Jasmine::SuiteFinder.find(data['suiteId']).jasmine_spec_started(data)
      end

      def jasmine_spec_done(data)
        Hotwire::Jasmine::SuiteFinder.find(data['suiteId']).jasmine_spec_done(data)
      end

      def jasmine_suite_done(data)
        Hotwire::Jasmine::SuiteFinder.find(data['suiteId']).jasmine_suite_done(data)
      end

      def jasmine_done(data)
        Hotwire::Jasmine::SuiteFinder.find(data['suiteId']).jasmine_done(data)
      end
    end
  end
end
