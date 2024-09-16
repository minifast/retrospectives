class Hotwire::Jasmine::SuitesController < Hotwire::Jasmine::ApplicationController
  def index
    @suites = Hotwire::Jasmine::SuiteFinder.resolve
  end

  def show
    @suite = Hotwire::Jasmine::SuiteFinder.find(params[:id])
  rescue KeyError
    raise ActiveRecord::RecordNotFound, params[:id]
  end
end
