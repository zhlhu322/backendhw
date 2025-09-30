class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to missions_path, notice: "已成功登入"
    else
      flash[:notice] = "登入失敗，請檢查帳號密碼"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to sign_in_path, notice: "已成功登出"
  end
end
