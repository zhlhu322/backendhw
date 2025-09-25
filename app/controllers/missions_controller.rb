class MissionsController < ApplicationController
  before_action :current_mission, only: [ :show, :edit, :update, :destroy ]

  def index
    @missions = Mission.all

    if params[:search].present?
      @missions = Mission.search(params[:search])
    end

    case params[:sort]
    when "created_at"
      @missions = @missions.order(created_at: :desc)
    when "end_date"
      @missions = @missions.order(end_date: :asc)
    else
      @missions = @missions.order(:id)
    end
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

  def mission_params
    params.require(:mission).permit(:name, :description, :end_date, :state)
  end

  def current_mission
    @mission = Mission.find(params[:id])
  end
end
