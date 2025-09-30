class ApplicationController < ActionController::Base
  before_action :current_user
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  include Pagy::Backend
  allow_browser versions: :modern
  helper_method :current_user

  private

  def current_user
    Current.user ||= User.find_by(id: session[:user_id])
  end

  def require_login
    return if Current.user.present?
    redirect_to sign_in_path, alert: "請先登入"
  end
end
