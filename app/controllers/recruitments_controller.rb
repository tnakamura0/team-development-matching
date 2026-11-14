class RecruitmentsController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]
  before_action :set_own_recruitment, only: [ :edit, :update, :destroy ]

  def index
    @recruitments = Recruitment.order(created_at: :desc)
  end

  def show
    @recruitment = Recruitment.find(params[:id])
  end

  def new
    @recruitment = Recruitment.new
  end

  def create
    @recruitment = Current.user.recruitments.new(recruitment_params)

    if @recruitment.save
      redirect_to recruitment_path(@recruitment), notice: "募集を作成しました"
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @recruitment.update(recruitment_params)
      redirect_to recruitment_path(@recruitment), notice: "募集を更新しました"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @recruitment.destroy!
    redirect_to recruitments_path, notice: "募集を削除しました", status: :see_other
  end

  private

  def recruitment_params
    params.require(:recruitment).permit(
      :title, :body, :closing_date, :positions_count, :required_status
    )
  end

  def set_own_recruitment
    @recruitment = Current.user.recruitments.find(params[:id])
  end
end
