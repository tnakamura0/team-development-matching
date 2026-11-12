class RecruitmentsController < ApplicationController
  allow_unauthenticated_access only: [ :index ]

  def index
    @recruitments = Recruitment.order(created_at: :desc)
  end
end
