class ReviewCriteriaController < ApplicationController
  before_action :set_review_criterium, only: [:show, :edit, :update, :destroy]

  # GET /review_criteria
  # GET /review_criteria.json
  def index
    @review_criteria = ReviewCriterium.all
  end

  # GET /review_criteria/1
  # GET /review_criteria/1.json
  def show
  end

  # GET /review_criteria/new
  def new
    @review_criterium = ReviewCriterium.new
  end

  # GET /review_criteria/1/edit
  def edit
  end

  # POST /review_criteria
  # POST /review_criteria.json
  def create
    @review_criterium = ReviewCriterium.new(review_criterium_params)

    respond_to do |format|
      if @review_criterium.save
        format.html { redirect_to @review_criterium, notice: 'Review criterium was successfully created.' }
        format.json { render :show, status: :created, location: @review_criterium }
      else
        format.html { render :new }
        format.json { render json: @review_criterium.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /review_criteria/1
  # PATCH/PUT /review_criteria/1.json
  def update
    respond_to do |format|
      if @review_criterium.update(review_criterium_params)
        format.html { redirect_to @review_criterium, notice: 'Review criterium was successfully updated.' }
        format.json { render :show, status: :ok, location: @review_criterium }
      else
        format.html { render :edit }
        format.json { render json: @review_criterium.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /review_criteria/1
  # DELETE /review_criteria/1.json
  def destroy
    @review_criterium.destroy
    respond_to do |format|
      format.html { redirect_to review_criteria_url, notice: 'Review criterium was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review_criterium
      @review_criterium = ReviewCriterium.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_criterium_params
      params.require(:review_criterium).permit(:name, :scale, :start_date, :end_date)
    end
end
