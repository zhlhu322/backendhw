class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])

    if user
      session[:user_id] = user.id
      redirect_to missions_path, notice: t("sessions.create.success")
    else
      flash[:notice] = t("sessions.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to sign_in_path, notice: t("sessions.destroy.success")
  end
end
