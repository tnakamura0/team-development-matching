class RecruitmentsController < ApplicationController
  allow_unauthenticated_access only: [ :index ]

  def index
    @recruitments = Recruitment.order(created_at: :desc)
  end

  def new
    @recruitment = Recruitment.new
  end

  def create
    @recruitment = Current.user.recruitments.new(recruitment_params)

    if @recruitment.save
      redirect_to recruitment_path(@recruitment),notice: "募集を作成しました"
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def recruitment_params
    params.require(:recruitment).permit(:title,:body,:closing_date,:positions_count,:required_status)
  end

end
