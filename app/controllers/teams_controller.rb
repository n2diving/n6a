class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @users = User.all
    # if current_user.is_admin
    #   @users = User.all
    # elsif current_user.teams.first.team_lead
    #   @users = User.joins(:employee_teams).where("employee_teams.team_id = ? ", current_user.teams.first.id)
    # end
    @team_reviews = @team.user_reviews
    @team_reviews_pending = @team_reviews.where(rate_period: (Date.today -1.month).end_of_month, is_team: true)
    @user_reviews_pending = @team_reviews.where(rate_period: (Date.today -1.month).end_of_month, is_team: false)
    @rate_periods = UserReview.all.pluck(:rate_period).uniq.sort.map{ |x| x.strftime("%B %Y") }
    @team_list = Team.where(id: UserReview.where.not(rating: nil).joins(user: { employee_teams: :team }).pluck(:team_id).uniq)

  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_team_reviews

    # @user_reviews = UserReview.order(:rate_period).joins(:review_item).where('review_items.is_team is true')

    @review_items = ReviewItem.order(:name).where(is_team: true, is_weekly: false)

    if current_user.is_admin || current_user.is_officer?
      @user_reviews = UserReview.joins(:review_item).where('review_items.is_team = true').joins(:review_note).where.not("review_notes.general_notes is null")
    else
      #if current_user.id == current_user.teams.first.try(:team_lead)
      @user_reviews = UserReview.joins(:review_item).where('review_items.is_team = true').left_outer_joins(:review_note).where(review_notes: { user_review_id: nil })
    # else
    #   flash[:notice] = "Sorry you don't have access to this page."
    #   redirect_to :root
    end

    if !@user_reviews.nil?
      @teams = Team.where(id: @user_reviews.joins(user: :employee_teams).pluck(:team_id).uniq)
    else
      @teams = []
    end
    
    @team_list = []

    if @teams.any?
      @teams.each do |one_team|

        if UserReview.where(user_id: EmployeeTeam.where(team_id: one_team.id, user_id: @user_reviews.pluck(:user_id)), is_team: true ).any?
          @team_list << one_team
        end
      end
    end


  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:team_name, :start_date, :end_date)
    end
end
