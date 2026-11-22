class ApplicationsController < ApplicationController
  before_action :set_own_application, only: [ :approve, :reject ]

  def create
    recruitment = Recruitment.find(params[:recruitment_id])
    application = recruitment.applications.new(user: Current.user)

    if application.save
      redirect_to recruitment_path(recruitment), notice: "応募しました"
    else
      redirect_to recruitment_path(recruitment), alert: application.errors.full_messages.to_sentence
    end
  end

  def approve
    if @application.approve
      redirect_to recruitment_path(@recruitment), notice: "承認しました", status: :see_other
    else
      redirect_to recruitment_path(@recruitment), alert: @application.errors.full_messages.to_sentence, status: :see_other
    end
  end

  def reject
    if @application.reject
      redirect_to recruitment_path(@recruitment), notice: "見送りました", status: :see_other
    else
      redirect_to recruitment_path(@recruitment), alert: @application.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private

  def set_own_application
    @recruitment = Current.user.recruitments.find(params[:recruitment_id])
    @application = @recruitment.applications.find(params[:id])
  end
end
