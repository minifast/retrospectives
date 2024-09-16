require 'rails_helper'

RSpec.describe Hotwire::Jasmine::SuitesChannel, type: :channel do
  around do |example|
    old_paths = Hotwire::Jasmine.configuration.paths
    Hotwire::Jasmine.configuration.paths = [Rails.root.join('spec/fixtures/jasmine')]
    example.run
  ensure
    Hotwire::Jasmine.configuration.paths = old_paths
  end

  before { subscribe }

  describe '#jasmine_started' do
    it 'sets a value inside the jasmine suite' do
      perform(:jasmine_started, suiteId: 'spec/fixtures/jasmine/example.spec', totalSpecsDefined: 5)
      expect(Hotwire::Jasmine::SuiteFinder.find('spec/fixtures/jasmine/example.spec').data)
        .to match(hash_including('totalSpecsDefined' => 5))
    end
  end

  describe '#jasmine_done' do
    it 'sets the done flag' do
      perform(:jasmine_done, suiteId: 'spec/fixtures/jasmine/example.spec')
      expect(Hotwire::Jasmine::SuiteFinder.find('spec/fixtures/jasmine/example.spec').data)
        .to match(hash_including('done' => true))
    end
  end
end
