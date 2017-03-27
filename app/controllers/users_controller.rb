class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :show, :update, :destroy, :new_employee_rating, :edit_team_rating]

  include ApplicationHelper


  # GET /users
  # GET /users.json
  def index
    if current_user.is_admin? || current_user.is_officer
      @users = User.current.without_admin.order(:last_name)
    # elsif current_user.id == current_user.teams.first.try(:team_lead)
    #   @users = User.joins(:employee_teams).where("employee_teams.team_id = ?", current_user.teams.first.id).order(:last_name)
    elsif current_user.can_review_users.any?
      @users = current_user.can_review_users
    else
      flash[:error] = "Sorry you don't have permission to view all employees."
      redirect_to :root
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user_reviews = @user.user_reviews
    @non_bonus_user_reviews = @user_reviews.joins(:review_item).where('review_items.is_weekly = false OR review_items.is_monthly_bonus = false')

    @rate_periods = UserReview.all.pluck(:rate_period).uniq.sort.map{ |x| x.strftime("%B %Y") }
    @months = I18n.t("date.month_names").drop(0)
    @team_list = Team.unhidden.where(id: UserReview.joins(user: { employee_teams: :team }).pluck(:team_id).uniq)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    #TODO this needs to be deleted/handled with UI or different function
    if @user.password.nil?
      generated_password = Devise.friendly_token.first(8)
      @user.password = generated_password
      @user.password_confirmation = @user.password
    end

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        if request.xhr?
          format.html { redirect_to :back }
          format.json { render :new_employee_rating, status: :ok }
        else
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        end
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def all_employees_ratings
    # @users = User.without_admin.order(:last_name)

    if true #current_user.is_admin? || current_user.is_officer
      @users = User.without_admin.order(:last_name)
    else
      flash[:error] = "Sorry you don't have permission to view all employees."
      redirect_to :root
    end

    if (params[:is_current] == nil) || (params[:is_current] == 'true')
      @users = @users.current
    end


    teams = params[:team_id]

    teammates = []
    @users = @users.where(id: params[:user_id]) if params[:user_id]
    @users = @users.where(form_role_id: params[:form_role_id]) if params[:form_role_id]
    if !teams.blank?
      teams.each do |one_team|
        team = Team.find(one_team)
        teammates = (teammates + team.teammates_by_month(params[:rate_period]).pluck(:id))
      end
      @users = @users.where(id: teammates)
    end

  end

  def new_employee_rating
    @user = User.where(id: params[:id])
    @user_review = UserReview.new
    if (current_user.is_admin? || current_user.is_officer)
      @users = User.without_admin.reorder(:last_name)
    elsif current_user.can_review_users.any?
      @users = current_user.can_review_users
    elsif current_user.id == current_user.current_team.try(:team_lead)
      @users = User.joins(:employee_teams).where("employee_teams.team_id = ?", current_user.current_team.id).reorder(:last_name)
      if !@users.pluck(:id).include? @user.first.id
        flash[:notice] = "Please select an employee in your group."
      end
    else
      flash[:alert] = "Sorry you don't have access to this page."
    end

    # raise

    @review_items_by_role = ReviewItemsByRole.where(form_role_id: @user.first.form_role_id).joins(:review_item).order('review_items.display_name').where(review_items: { is_team: false, is_weekly: false, is_monthly_bonus: false } )

    @bonus_items_by_role = ReviewItemsByRole.where(form_role_id: @user.first.form_role_id).joins(:review_item).order('review_items.display_name').where(review_items: { is_team: false }).where('review_items.is_weekly = true OR review_items.is_monthly_bonus = true')


    # @review_items = ReviewItem.order(:name).where(is_team: false, is_weekly: false)
  end

  def edit_employee_rating
    @user = User.find(params[:id])
    month = params[:rate_period].blank? ? (current_month) : params[:rate_period].to_date.end_of_month

    @user_reviews = @user.user_reviews.where(rate_period: month).joins(:review_item).order('review_items.display_name').where('review_items.is_team = false')
  end

  def update_all

    @user = User.find(params[:user][:id].to_i)
    # begin
      params[:user_reviews].keys.each do |one_review|
        if !params[:user_reviews][one_review][:multiplier].nil? && (params[:user_reviews][one_review][:multiplier].to_i > 0)
          check = true
        else
          check = (params[:user_reviews][one_review][:checked].nil? ? false : true)
        end

        rating_value = params[:user_reviews][one_review][:rating].nil? ? nil : params[:user_reviews][one_review][:rating]

        user_review = UserReview.find(one_review)
        user_review.update_attributes(
          pros: params[:user_reviews][one_review][:pros],
          cons: params[:user_reviews][one_review][:cons],
          notes: params[:user_reviews][one_review][:notes],
          rating: rating_value,
          rated_by_user_id: params[:user_reviews][one_review][:rated_by_user_id],
          checked: check,
          multiplier: params[:user_reviews][one_review][:multiplier]
        )
      end
      redirect_to users_url, notice: "Employee review has been updated."
    # rescue => e
    #   redirect_to :back, notice: e.inspect
    # end
  end

  def update_all_team

    team = Team.find(params[:user][:team_id])

    employee_ids = team.employee_teams.pluck(:user_id).uniq


    users = User.where(id: employee_ids)
    current_month_teammates = []
    users.each do |one|
      if one.current_team == team
        current_month_teammates << one
      end
    end


    # begin
    current_month_teammates.each do |one_user|
        params[:user_reviews].keys.each do |one_review|
          user_review = UserReview.where(id: one_review)
          if !params[:user_reviews][one_review][:multiplier].nil? && (params[:user_reviews][one_review][:multiplier].to_i > 0)
            check = true
          else
            check = (params[:user_reviews][one_review][:checked].nil? ? false : true)
          end

          rating_value = params[:user_reviews][one_review][:rating].nil? ? nil : params[:user_reviews][one_review][:rating]
          if user_review.any?
            user_review.first.update_attributes(
              pros: params[:user_reviews][one_review][:pros],
              cons: params[:user_reviews][one_review][:cons],
              notes: params[:user_reviews][one_review][:notes],
              rating: rating_value,
              checked: check,
              multiplier: params[:user_reviews][one_review][:multiplier],
              rated_by_user_id: params[:user_reviews][one_review][:rated_by_user_id]
            )
            ReviewNote.create!(
              user_review_id: one_review,
              general_notes: params[:general_notes]
            )
          else
            user_review = UserReview.create(
              user_id: one_user.id,
              review_item_id: params[:user_reviews][one_review][:review_item_id],
              rate_period: params[:user_reviews][one_review][:rate_period],
              pros: params[:user_reviews][one_review][:pros],
              cons: params[:user_reviews][one_review][:cons],
              notes: params[:user_reviews][one_review][:notes],
              rating: rating_value,
              checked: check,
              multiplier: params[:user_reviews][one_review][:multiplier],
              rated_by_user_id: params[:user_reviews][one_review][:rated_by_user_id],
              is_team: true,
              notes_allowed: true,
              team_id: team.id
              )
            user_review.review_note.create(
              general_notes: params[:general_notes]
            )
          end

        end
      end

      redirect_to team, notice: "Group rating has been saved."
    # rescue => e
    #   redirect_to back, notice: e.inspect
    # end

  end

  def employee_rating
    # begin
      user = User.find(params[:id])
      team = user.current_team

      params[:user_reviews].keys.each do |one_review|
        if !params[:user_reviews][one_review][:multiplier].nil? && (params[:user_reviews][one_review][:multiplier].to_i > 0)
          check = true
        else
          check = (params[:user_reviews][one_review][:checked].nil? ? false : true)
        end

        rating_value = params[:user_reviews][one_review][:rating].nil? ? nil : params[:user_reviews][one_review][:rating]


        UserReview.create!(
          user_id: user.id,
          review_item_id: params[:user_reviews][one_review][:review_item_id],
          review_items_by_role_id: params[:user_reviews][one_review][:review_items_by_role_id],
          rate_period: params[:user_reviews][one_review][:rate_period],
          pros: params[:user_reviews][one_review][:pros],
          cons: params[:user_reviews][one_review][:cons],
          notes: params[:user_reviews][one_review][:notes],
          rating: rating_value,
          rated_by_user_id: params[:user_reviews][one_review][:rated_by_user_id],
          is_team: false,
          checked: check,
          multiplier: params[:user_reviews][one_review][:multiplier],
          team_id: team.id
        )
      end
      redirect_to user, notice: "Employee rating has been saved."
    # rescue => e
    #   redirect_to back, notice: e.inspect
    # end

  end

  def new_team_rating
    if params[:team_id]
      team = Team.find(params[:team_id])
      @user = [User.joins(:employee_teams).where('employee_teams.team_id = ?', team.id).first]
      if @user.first.nil?
        flash[:notice] = "Sorry there are no employees on #{team.team_name} to rate."
        redirect_to :teams
      end
    else
      @user = [User.new]
    end

    form_role_id = FormRole.unscoped.where(role: 'Team').first.id
    @review_items_by_role = ReviewItemsByRole.where(form_role_id: form_role_id).joins(:review_item).order('review_items.display_name').where(review_items: { is_team: true, is_weekly: false, is_monthly_bonus: false } )

    @bonus_items_by_role = ReviewItemsByRole.where(form_role_id: form_role_id).joins(:review_item).order('review_items.display_name').where(review_items: { is_team: true }).where('review_items.is_weekly = true OR review_items.is_monthly_bonus = true')

    #
    # @review_items = ReviewItem.order(:display_name).where(is_team: true).where(is_monthly_bonus: false)
    #
    # @bonus_items= ReviewItem.order(:display_name).where(is_team: true).where(is_monthly_bonus: true)

  end

  def edit_team_rating
    @user = User.find(params[:id])

    @reviews = UserReview.where(id: params[:reviews])
    team = @reviews.pluck(:team_id).uniq.first
    if team
      @teammates = EmployeeTeam.where(team_id: @reviews.pluck(:team_id).uniq)
    end

    month = params[:rate_period].blank? ? (current_month) : params[:rate_period].to_date.end_of_month

    # @reviews = UserReview.where(user_id: EmployeeTeam.where(team_id: team.id, user_id: @teammates.pluck(:user_id)), is_team: true, rate_period: month).joins(:review_item).where('review_items.is_team = true').left_outer_joins(:review_note).where(review_notes: { user_review_id: nil })

    @user_reviews = []

    @reviews.pluck(:review_item_id).uniq.each do |one_review_item_id|
      @user_reviews << @reviews.where(review_item_id: one_review_item_id).first
    end
    @user_reviews


    # UserReview.where(user_id: EmployeeTeam.where(team_id: one_team.id, user_id: @user_reviews.pluck(:user_id)), is_team: true, rate_period: month)



    # @user_reviews = UserReview.joins(:review_item).where('review_items.is_team = true').left_outer_joins(:review_note).where(review_notes: { user_review_id: nil })

  end

  def team_rating
    team = Team.find(params[:team_id])

    employee_ids = team.employee_teams.pluck(:user_id).uniq

    users = User.where(id: employee_ids)
    current_month_teammates = []
    users.each do |one|
      if one.current_team == team
        current_month_teammates << one
      end
    end


    # begin
      current_month_teammates.each do |one_user|
        params[:user_reviews].keys.each do |one_review|

          if params[:user_reviews][one_review][:review_item_id].include?(">")
            review_item_id = params[:user_reviews][one_review][:review_item_id].split(">")[1].split("}")[0]
          else
            review_item_id = params[:user_reviews][one_review][:review_item_id]
          end

          rating_value = params[:user_reviews][one_review][:rating].nil? ? nil : params[:user_reviews][one_review][:rating]

          UserReview.create!(
            user_id: one_user.id,
            review_item_id: review_item_id,
            review_items_by_role_id: params[:user_reviews][one_review][:review_items_by_role_id],
            rate_period: params[:user_reviews][one_review][:rate_period],
            notes: params[:user_reviews][one_review][:notes],
            rating: rating_value,
            rated_by_user_id: params[:user_reviews][one_review][:rated_by_user_id],
            is_team: true,
            notes_allowed: true,
            checked: (params[:user_reviews][one_review][:checked].nil? ? false : true),
            team_id: team.id
          )
        end
      end

      redirect_to team, notice: "Group rating has been saved."
    # rescue => e
    #   redirect_to :back, notice: e.inspect
    # end

  end

  def employees_with_pending_reviews
    @user_reviews = UserReview.order(:rate_period).joins(:review_item).where('review_items.is_team is false')
    # @review_items = ReviewItem.order(:name).where(is_team: true, is_weekly: false)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      id = (params[:id]) || current_user.id
      @user = User.find(id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      # params.fetch(:user, {})
      params.require(:user).permit(:id, :first_name, :last_name, :title, :is_current, :start_date, :email, :is_officer, :is_admin, :password, :password_confirmation, :id, :review_item_id, :review_items_by_role_id, :rated_by_user_id, :notes_allowed, :rate_period, :rating, :is_team, :pros, :cons, :notes,:user_reviews, :form_role_id, user_reviews_attributes: [:id, :review_item_id, :rated_by_user_id, :notes_allowed, :rate_period, :rating, :is_team, :pros, :cons, :notes, :checked, :multiplier, review_notes_attributes: [:user_review_id, :general_notes, :pros, :cons] ],)
    end
end