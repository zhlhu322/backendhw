class MissionsController < ApplicationController
  before_action :current_mission, only: [ :show, :edit, :update, :destroy ]

  def index
    @missions = Mission.all
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
      render :new
    end
  end

  def edit
  end

  def update
    if @mission.update(mission_params)
      flash[:notice] = t("missions.edit.success")
      redirect_to mission_path(@mission)
    else
      render :edit
    end
  end

  def destroy
    @mission.destroy
    flash[:notice] = t("missions.delete.success")
    redirect_to missions_path
  end

  def mission_params
    params.require(:mission).permit(:name, :description)
  end

  def current_mission
    @mission = Mission.find(params[:id])
  end
end
