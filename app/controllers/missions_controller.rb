class MissionsController < ApplicationController
  def index
    @missions = Mission.all
  end

  def show
    @mission = Mission.find(params[:id])
  end

  def new
    @mission = Mission.new
  end

  def create
    @mission = Mission.new(mission_params)
    if @mission.save
      flash[:notice] = "Mission created successfully!"
      redirect_to mission_path(@mission)
    else
      render :new
    end
  end

  def edit
    @mission = Mission.find(params[:id])
  end

  def update
    @mission = Mission.find(params[:id])
    flash[:notice] = "Mission updated successfully!"
    if @mission.update(mission_params)
      redirect_to mission_path(@mission)
    else
      render :edit
    end
  end

  def destroy
    @mission = Mission.find(params[:id])
    @mission.destroy
    flash[:notice] = "Mission deleted."
    redirect_to missions_path
  end

  def mission_params
    params.require(:mission).permit(:name, :description)
  end
end
