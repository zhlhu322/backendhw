class Admin::BaseController < ApplicationController
  # before_action :require_admin_login
  # before_action :check_admin

  # private

  # def require_admin_login
  #   redirect_to(sign_in_path, alert: "請先登入") unless Current.user.present
  # end

  # def check_admin
  #   redirect_to(admin_login_path, alert: "請以管理員身分登入") unless current_user.admin
  # end
end
