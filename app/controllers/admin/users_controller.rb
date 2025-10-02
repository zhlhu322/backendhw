class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]
  def index
    @pagy, @users = pagy(user_scope)
  end

  def new
    @user = User.new
  end

  def show
  end

  def create
    @user = User.new(user_params)
    @user.admin = params[:user][:admin]
    if @user.save
      flash[:notice] = t("users.create.success")
      redirect_to admin_users_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = t("users.edit.success")
      redirect_to admin_users_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = t("users.delete.success")
      redirect_to admin_users_path
    else
      redirect_to admin_users_path, alert: @user.errors.full_messages.to_sentence
    end
  end

  private
  def user_scope
    User.all.includes(:missions)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
