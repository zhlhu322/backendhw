class Admin::BaseController < ApplicationController
  before_action :require_admin

  private
  def require_admin
    return (redirect_to new_admin_session_path, alert: t("base.alert.require_login")) unless Current.user.present?
    return (redirect_to new_admin_session_path, alert: t("base.alert.check_admin")) unless current_user.admin?
    nil
  end
end
