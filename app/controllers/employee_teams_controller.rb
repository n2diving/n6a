class EmployeeTeamsController < ApplicationController
  before_action :set_employee_team, only: [:show, :edit, :update, :destroy]

  # GET /employee_teams
  # GET /employee_teams.json
  def index
    @employee_teams = EmployeeTeam.all
  end

  # GET /employee_teams/1
  # GET /employee_teams/1.json
  def show
  end

  # GET /employee_teams/new
  def new
    @employee_team = EmployeeTeam.new
  end

  # GET /employee_teams/1/edit
  def edit
  end

  # POST /employee_teams
  # POST /employee_teams.json
  def create
    @employee_team = EmployeeTeam.new(employee_team_params)

    respond_to do |format|
      if @employee_team.save
        format.html { redirect_to @employee_team, notice: 'Employee team was successfully created.' }
        format.json { render :show, status: :created, location: @employee_team }
      else
        format.html { render :new }
        format.json { render json: @employee_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employee_teams/1
  # PATCH/PUT /employee_teams/1.json
  def update
    respond_to do |format|
      if @employee_team.update(employee_team_params)
        format.html { redirect_to @employee_team, notice: 'Employee team was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee_team }
      else
        format.html { render :edit }
        format.json { render json: @employee_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employee_teams/1
  # DELETE /employee_teams/1.json
  def destroy
    @employee_team.destroy
    respond_to do |format|
      format.html { redirect_to employee_teams_url, notice: 'Employee team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee_team
      @employee_team = EmployeeTeam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_team_params
      params.require(:employee_team).permit(:user_id, :team_lead, :supervisor, :team_id)
    end
end
