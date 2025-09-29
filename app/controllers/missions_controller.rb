class MissionsController < ApplicationController
  before_action :current_mission, only: [ :show, :edit, :update, :destroy ]

  def index
    @pagy, @missions = pagy(mission_scope)
  end

  def show
  end

  def new
    @mission = Mission.new
  end

  def create
    @mission = Mission.new(mission_params)
    if @mission.save
      flash[:notice] = t("missions.create.success")
      redirect_to mission_path(@mission)
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @mission.update(mission_params)
      flash[:notice] = t("missions.edit.success")
      redirect_to mission_path(@mission)
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @mission.destroy
    flash[:notice] = t("missions.delete.success")
    redirect_to missions_path
  end

  private

  def mission_scope
    Mission.includes(:user).search(search_query).controller_sort(sort_option)
  end

  def search_query
    params[:search]
  end

  def sort_option
    params[:sort]
  end

  def mission_params
    params.require(:mission).permit(:name, :description, :end_date, :state, :priority)
  end

  def current_mission
    @mission = Mission.find(params[:id])
  end
end
