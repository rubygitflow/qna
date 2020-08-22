class SearchController < ApplicationController
  def index
    authorize! :index, :search

    @results = Search.new(params[:context], params[:q]).call
  end
end
