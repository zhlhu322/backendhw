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
    @mission = current_user.missions.new(mission_params.except(:tag_name))

    if @mission.save
      @mission.add_tag_by_name(mission_params[:tag_name])
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
    if current_mission.update(mission_params.except(:tag_name))
      current_mission.add_tag_by_name(mission_params[:tag_name])
      flash[:notice] = t("missions.edit.success")
      redirect_to mission_path(current_mission)
    else
      puts "Validation Failed: #{current_mission.errors.full_messages}"
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
    current_user.missions.search(search_query, sort_option)
  end

  def search_query
    params[:search]
  end

  def sort_option
    params[:sort]
  end

  def mission_params
    params.require(:mission).permit(:name, :description, :end_date, :state, :priority, :tag_name,
      taggings_attributes: [ :id, :_destroy ])
  end

  def current_mission
    @mission = mission_scope.find(params[:id])
  end
  helper_method :current_mission
end
