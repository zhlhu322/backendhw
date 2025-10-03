class MissionsController < ApplicationController
  before_action :require_login

  def index
    @pagy, @missions = pagy(mission_scope)
  end

  def show
  end

  def new
    @mission = Mission.new
  end

  def create
    @mission = Current.user.missions.new(mission_params.except(:tags))
    @mission.tags = @mission.add_tag(params[:mission][:tags])

    if @mission.save
      flash[:notice] = t("missions.create.success")
      redirect_to mission_path(@mission)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @mission = current_mission
  end

  def update
    all_tags = current_mission.add_tag(params[:mission][:tags])
    if current_mission.update(mission_params.except(:tags).merge(tags: all_tags))
      flash[:notice] = t("missions.edit.success")
      redirect_to mission_path(current_mission)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_mission.destroy
    flash[:notice] = t("missions.delete.success")
    redirect_to missions_path
  end

  private

  def mission_scope
    Current.user.missions.includes(:user).search(search_query).controller_sort(sort_option)
  end

  def search_query
    params[:search]
  end

  def sort_option
    params[:sort]
  end

  def mission_params
    params.require(:mission).permit(:name, :description, :end_date, :state, :priority, tags: [])
  end

  def current_mission
    @mission = mission_scope.find(params[:id])
  end
  helper_method :current_mission
end
