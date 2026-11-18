class ApplicationsController < ApplicationController
  def create
    recruitment = Recruitment.find(params[:recruitment_id])
    application = recruitment.applications.new(user: Current.user)

    if application.save
      redirect_to recruitment_path(recruitment), notice: "応募しました"
    else
      redirect_to recruitment_path(recruitment), alert: application.errors.full_messages.to_sentence
    end
  end
end
