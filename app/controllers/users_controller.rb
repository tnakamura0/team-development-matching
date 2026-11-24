class UsersController < ApplicationController
  before_action :set_current_user, only: [ :show, :edit, :update ]

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: t(".success")
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_current_user
    raise ActiveRecord::RecordNotFound unless params[:id].to_s == Current.user.id.to_s
    @user = Current.user
  end

  def user_params
    params.require(:user).permit(:name, :period, :required_status)
  end
end
