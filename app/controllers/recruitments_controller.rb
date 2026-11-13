class RecruitmentsController < ApplicationController
  allow_unauthenticated_access only: [ :index ]

  def index
    @recruitments = Recruitment.order(created_at: :desc)
  end

  def destroy
    recruitment = Current.user.recruitments.find(params[:id])
    recruitment.destroy!
    redirect_to recruitments_path, notice: "募集を削除しました", status: :see_other
  end
end
