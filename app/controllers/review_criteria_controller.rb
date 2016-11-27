class ReviewCriteriaController < ApplicationController
  before_action :set_review_criteria, only: [:show, :edit, :update, :destroy]

  # GET /review_criteria
  # GET /review_criteria.json
  def index
    @review_criteria = ReviewCriteria.all
  end

  # GET /review_criteria/1
  # GET /review_criteria/1.json
  def show
  end

  # GET /review_criteria/new
  def new
    @review_criteria = ReviewCriteria.new
  end

  # GET /review_criteria/1/edit
  def edit
  end

  # POST /review_criteria
  # POST /review_criteria.json
  def create
    @review_criteria = ReviewCriteria.new(review_criteria_params)

    respond_to do |format|
      if @review_criteria.save
        format.html { redirect_to review_criteria_path, notice: 'Review criterium was successfully created.' }
        format.json { render :show, status: :created, location: @review_criteria }
      else
        format.html { render :new }
        format.json { render json: @review_criteria.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /review_criteria/1
  # PATCH/PUT /review_criteria/1.json
  def update
    respond_to do |format|
      if @review_criteria.update(review_criteria_params)
        format.html { redirect_to @review_criteria, notice: 'Review criterium was successfully updated.' }
        format.json { render :show, status: :ok, location: @review_criteria }
      else
        format.html { render :edit }
        format.json { render json: @review_criteria.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /review_criteria/1
  # DELETE /review_criteria/1.json
  def destroy
    @review_criteria.destroy
    respond_to do |format|
      format.html { redirect_to review_criteria_url, notice: 'Review criterium was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review_criteria
      @review_criteria = ReviewCriteria.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_criteria_params
      params.require(:review_criteria).permit(:name, :scale_min, :scale_max, :start_date, :end_date, :short_name, :evaluation_criteria)
    end
end
