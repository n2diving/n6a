class ReviewItemsByRolesController < ApplicationController
  before_action :set_review_items_by_role, only: [:show, :edit, :update, :destroy]

  # GET /review_items_by_roles
  # GET /review_items_by_roles.json
  def index
    @review_items_by_roles = ReviewItemsByRole.all
  end

  # GET /review_items_by_roles/1
  # GET /review_items_by_roles/1.json
  def show
  end

  # GET /review_items_by_roles/new
  def new
    @review_items_by_role = ReviewItemsByRole.new
  end

  # GET /review_items_by_roles/1/edit
  def edit
  end

  # POST /review_items_by_roles
  # POST /review_items_by_roles.json
  def create
    @review_items_by_role = ReviewItemsByRole.new(review_items_by_role_params)

    respond_to do |format|
      if @review_items_by_role.save
        format.html { redirect_to @review_items_by_role, notice: 'Review items by role was successfully created.' }
        format.json { render :show, status: :created, location: @review_items_by_role }
      else
        format.html { render :new }
        format.json { render json: @review_items_by_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /review_items_by_roles/1
  # PATCH/PUT /review_items_by_roles/1.json
  def update
    respond_to do |format|
      if @review_items_by_role.update(review_items_by_role_params)
        format.html { redirect_to @review_items_by_role, notice: 'Review items by role was successfully updated.' }
        format.json { render :show, status: :ok, location: @review_items_by_role }
      else
        format.html { render :edit }
        format.json { render json: @review_items_by_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /review_items_by_roles/1
  # DELETE /review_items_by_roles/1.json
  def destroy
    @review_items_by_role.destroy
    respond_to do |format|
      format.html { redirect_to review_items_by_roles_url, notice: 'Review items by role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review_items_by_role
      @review_items_by_role = ReviewItemsByRole.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_items_by_role_params
      params.require(:review_items_by_role).permit(:review_item_id, :form_role_id, :evaluation_criteria, :short_label)
    end
end
