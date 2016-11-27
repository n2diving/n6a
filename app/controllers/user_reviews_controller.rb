class UserReviewsController < ApplicationController
  before_action :set_user_review, only: [:show, :edit, :update, :destroy]

  # GET /user_reviews
  # GET /user_reviews.json
  def index
    @user_reviews = UserReview.all
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
        format.html { redirect_to @user_review, notice: 'User review was successfully created.' }
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
        format.html { redirect_to @user_review, notice: 'User review was successfully updated.' }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_review
      @user_review = UserReview.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_review_params
      params.require(:user_review).permit(:review_criteria_id, :user_id, :rated_by_user_id, :notes_allowed, :rate_period)
    end
end