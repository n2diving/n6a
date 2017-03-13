class TeamOfTheMonthsController < ApplicationController
  before_action :set_team_of_the_month, only: [:show, :edit, :update, :destroy]

  # GET /team_of_the_months
  # GET /team_of_the_months.json
  def index
    @team_of_the_months = TeamOfTheMonth.all
  end

  # GET /team_of_the_months/1
  # GET /team_of_the_months/1.json
  def show
  end

  # GET /team_of_the_months/new
  def new
    @team_of_the_month = TeamOfTheMonth.new
  end

  # GET /team_of_the_months/1/edit
  def edit
  end

  # POST /team_of_the_months
  # POST /team_of_the_months.json
  def create
    @team_of_the_month = TeamOfTheMonth.new(team_of_the_month_params)

    respond_to do |format|
      if @team_of_the_month.save
        format.html { redirect_to @team_of_the_month, notice: 'Team of the month was successfully created.' }
        format.json { render :show, status: :created, location: @team_of_the_month }
      else
        format.html { render :new }
        format.json { render json: @team_of_the_month.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /team_of_the_months/1
  # PATCH/PUT /team_of_the_months/1.json
  def update
    respond_to do |format|
      if @team_of_the_month.update(team_of_the_month_params)
        format.html { redirect_to @team_of_the_month, notice: 'Team of the month was successfully updated.' }
        format.json { render :show, status: :ok, location: @team_of_the_month }
      else
        format.html { render :edit }
        format.json { render json: @team_of_the_month.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /team_of_the_months/1
  # DELETE /team_of_the_months/1.json
  def destroy
    @team_of_the_month.destroy
    respond_to do |format|
      format.html { redirect_to team_of_the_months_url, notice: 'Team of the month was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team_of_the_month
      @team_of_the_month = TeamOfTheMonth.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_of_the_month_params
      params.require(:team_of_the_month).permit(:name, :rate_period)
    end
end
