class ReviewItemsController < ApplicationController
  before_action :set_review_item, only: [:show, :edit, :update, :destroy]

  # GET /review_items
  # GET /review_items.json
  def index
    @review_items = ReviewItem.all
  end

  # GET /review_items/1
  # GET /review_items/1.json
  def show
  end

  # GET /review_items/new
  def new
    @review_item = ReviewItem.new
  end

  # GET /review_items/1/edit
  def edit
  end

  # POST /review_items
  # POST /review_items.json
  def create
    @review_item = ReviewItem.new(review_item_params)

    respond_to do |format|
      if @review_item.save
        format.html { redirect_to review_items_url, notice: 'Review item was successfully created.' }
        format.json { render :show, status: :created, location: @review_item }
      else
        format.html { render :new }
        format.json { render json: @review_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /review_items/1
  # PATCH/PUT /review_items/1.json
  def update
    respond_to do |format|
      if @review_item.update(review_item_params)
        format.html { redirect_to review_items_url, notice: 'Review item was successfully updated.' }
        format.json { render :show, status: :ok, location: @review_item }
      else
        format.html { render :edit }
        format.json { render json: @review_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /review_items/1
  # DELETE /review_items/1.json
  def destroy
    @review_item.destroy
    respond_to do |format|
      format.html { redirect_to review_items_url, notice: 'Review item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review_item
      @review_item = ReviewItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_item_params
      params.require(:review_item).permit(:name, :display_name, :evaluation_criteria, :scale_min, :scale_max, :start_date,:end_date, :response_allowed, :is_team, :is_weekly, :is_displayed )
    end
end
