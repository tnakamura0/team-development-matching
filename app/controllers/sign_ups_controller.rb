class SignUpsController < ApplicationController
  allow_unauthenticated_access
  before_action :redirect_if_authenticated
  def show
    @user = User.new
  end

  def create
    @user = User.new(sign_up_params)
    if @user.save
      start_new_session_for(@user)
      redirect_to root_path, notice: t("controllers.sign_ups.create.success")
    else
      flash.now[:alert] = t("controllers.sign_ups.create.failure")

      render :show, status: :unprocessable_entity
    end
  end

  private
    def sign_up_params
      params.expect(user: [ :name, :email_address, :password, :password_confirmation ])
    end
end
