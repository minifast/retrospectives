require 'rails_helper'

RSpec.describe 'Running a Jasmine suite', type: :system do
  around do |example|
    old_paths = Hotwire::Jasmine.configuration.paths
    Hotwire::Jasmine.configuration.paths = [Rails.root.join('spec/fixtures/jasmine')]
    example.run
  ensure
    Hotwire::Jasmine.configuration.paths = old_paths
  end

  it 'reports statuses', :js do
    visit hotwire_jasmine_suites_path

    expect(page).to have_css('#spec-fixtures-jasmine-example-spec', visible: :all)

    timeout = 5.seconds.from_now
    until timeout.past?
      break if Hotwire::Jasmine::SuiteFinder.resolve.all?(&:done?)
    end
    expect(timeout).not_to be_past
  end
end
