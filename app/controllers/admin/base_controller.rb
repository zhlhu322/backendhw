class Admin::BaseController < ApplicationController
  before_action :require_admin_login
  before_action :check_admin

  private

  def require_admin_login
    return if Current.user.present?
    flash[:alert] = t("base.alert.require_login")
    redirect_to new_admin_session_path
  end

  def check_admin
    return if current_user.admin
    flash[:alert] = t("base.alert.check_admin")
    redirect_to new_admin_session_path
  end
end
