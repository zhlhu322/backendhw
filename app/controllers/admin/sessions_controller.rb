class Admin::SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password]) && user.admin?
      session[:user_id] = user.id
      redirect_to admin_users_path, notice: t("sessions.create.success")
    else
      flash[:alert] = t("sessions.create.admin_failure")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_admin_session_path, notice: t("sessions.destroy.success")
  end
end
