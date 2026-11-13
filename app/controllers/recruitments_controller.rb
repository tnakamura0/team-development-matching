class RecruitmentsController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]

  def index
    @recruitments = Recruitment.order(created_at: :desc)
  end

  def show
    @recruitment = Recruitment.find(params[:id])
  end
end
