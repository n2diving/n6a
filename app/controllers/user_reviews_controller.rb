class UserReviewsController < ApplicationController
  before_action :set_user_review, only: [:show, :edit, :update, :destroy]

  include TeamsHelper

  # GET /user_reviews
  # GET /user_reviews.json
  def index
    @user_reviews = UserReview.all.order(:rate_period).page(params[:page])
  end

  # GET /user_reviews/1
  # GET /user_reviews/1.json
  def show
  end

  # GET /user_reviews/new
  def new
    @user_review = UserReview.new
  end

  # GET /user_reviews/1/edit
  def edit
  end

  # POST /user_reviews
  # POST /user_reviews.json
  def create
    @user_review = UserReview.new(user_review_params)

    respond_to do |format|
      if @user_review.save
        format.html { redirect_to user_reviews_path, notice: 'User review was successfully created.' }
        format.json { render :show, status: :created, location: @user_review }
      else
        format.html { render :new }
        format.json { render json: @user_review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_reviews/1
  # PATCH/PUT /user_reviews/1.json
  def update
    respond_to do |format|
      if @user_review.update(user_review_params)
        format.html { redirect_to user_reviews_path, notice: 'User review was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_review }
      else
        format.html { render :edit }
        format.json { render json: @user_review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_reviews/1
  # DELETE /user_reviews/1.json
  def destroy
    @user_review.destroy
    respond_to do |format|
      format.html { redirect_to user_reviews_url, notice: 'User review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def monthly_analysis
    month = params[:rate_period].blank? ? ((Date.today).end_of_month) : params[:rate_period].to_date.end_of_month
    totm_user_id = UserReview.where(rate_period: month).joins(:review_item). where(review_items: { is_team: false, is_monthly_bonus: true}).try(:user_id)
    totm = !totm_user_id.blank? ? EmployeeTeam.where(user_id: totm_user_id).team.team_name : nil
    employee_average = employee_average_high_low(month)

    @group_of_the_month = Team.find(team_ranking(Team.first.id, month)).team_name
    @team_of_the_month = totm.nil? ? 'No team has been selected for this month.' : totm
    @producers_of_the_week = User.where(id: UserReview.where(rate_period: month).joins(:review_item).where(review_items: { is_team: false, is_weekly: true}).pluck(:user_id))
    @individual_by_level = individual_averages_by_role(month)
    @team_variance = {
      "average team member" => team_variance(month),
      "highest individual average" => employee_average[:high],
      "lowest individual average" => employee_average[:low]
    }
    @highest_by_level = highest_kpi_average_by_role(month)
    @lowest_by_level = highest_kpi_average_by_role(month)

  end

  def individual_averages_by_role(rate_period)

    review_list = UserReview.where(rate_period: rate_period).where.not(rating: nil).joins(:review_items_by_role)

    roles = FormRole.no_team
    results = {}
    roles.each do |one_role|
      data = review_list.where('review_items_by_roles.form_role_id = ?', one_role.id)
      results[one_role.role] = (data.blank? ? 0 : ('%.2f' % (data.sum(:rating) / data.count.to_f).round(2)))
    end

    results
  end

  def team_variance(rate_period)
    results = []
    Team.all.each do |one_team|
      unless team_averages(one_team.id, rate_period, rate_period).to_i == 0
        results << team_averages(one_team.id, rate_period, rate_period).to_i
      end
    end

    results.blank? ? 0 : ('%.2f' % (results.reduce(&:+) / results.length.to_f).round(2))
  end

  def employee_average_high_low(rate_period)

    list = UserReview.where(rate_period: rate_period).where.not(rating: nil)
    ratings = []
    User.all.pluck(:id).each do |one_user_id|
      data = list.where(user_id: one_user_id)
        ratings << ((data.sum(:rating) / data.count) if !data.blank?)
    end

    ratings.reject! {|x| x == nil}
    ratings.reject! {|x| x == 0}
    ratings.sort!

    results = {
      low: '%.2f' % ratings.first,
      high: '%.2f' % ratings.last
    }

  end

  def highest_kpi_average_by_role(rate_period)

    review_list = UserReview.where(rate_period: rate_period).where.not(rating: nil).joins(:review_item, :review_items_by_role)

    items = ReviewItem.where(is_weekly: false, is_monthly_bonus: false)
    roles = FormRole.no_team
    results = {}
    roles.each do |one_role|
      results[one_role.role] = {}
      items.each do |one_item|
        data = review_list.where(user_reviews: { review_item_id: one_item.id }).where('review_items_by_roles.form_role_id = ?', one_role.id)
        average = (data.blank? ? 0 : ('%.2f' % (data.sum(:rating) / data.count.to_f).round(2)))
        results[one_role.role][one_item.display_name] = average
      end
    end

    results.each_with_index do |k,v|
      results[k.first] = results[k.first].sort_by {|k,v| v.to_f}.reverse.to_h
    end

    results

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_review
      @user_review = UserReview.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_review_params
      params.require(:user_review).permit(:review_item_id, :user_id, :rated_by_user_id, :notes_allowed, :rate_period, :rating, :is_team, :pros, :cons, :notes, :is_archived, :checked, :multiplier)
    end
end