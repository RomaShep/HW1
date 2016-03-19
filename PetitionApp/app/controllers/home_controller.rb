class HomeController < ApplicationController
  def index
    @petitions = Petition.order(created_at: :desc).limit(10)
  end
end