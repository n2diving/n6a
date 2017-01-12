class EmployeeReviewersController < ApplicationController
  before_action :set_employee_reviewer, only: [:show, :edit, :update, :destroy]

  # GET /employee_reviewers
  # GET /employee_reviewers.json
  def index
    @employee_reviewers = EmployeeReviewer.all
  end

  # GET /employee_reviewers/1
  # GET /employee_reviewers/1.json
  def show
  end

  # GET /employee_reviewers/new
  def new
    @employee_reviewer = EmployeeReviewer.new
  end

  # GET /employee_reviewers/1/edit
  def edit
  end

  # POST /employee_reviewers
  # POST /employee_reviewers.json
  def create
    @employee_reviewer = EmployeeReviewer.new(employee_reviewer_params)

    respond_to do |format|
      if @employee_reviewer.save
        format.html { redirect_to employee_reviewers_url, notice: 'Employee reviewer was successfully created.' }
        format.json { render :show, status: :created, location: @employee_reviewer }
      else
        format.html { render :new }
        format.json { render json: @employee_reviewer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employee_reviewers/1
  # PATCH/PUT /employee_reviewers/1.json
  def update
    respond_to do |format|
      if @employee_reviewer.update(employee_reviewer_params)
        format.html { redirect_to @employee_reviewer, notice: 'Employee reviewer was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee_reviewer }
      else
        format.html { render :edit }
        format.json { render json: @employee_reviewer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employee_reviewers/1
  # DELETE /employee_reviewers/1.json
  def destroy
    @employee_reviewer.destroy
    respond_to do |format|
      format.html { redirect_to employee_reviewers_url, notice: 'Employee reviewer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def all_employees
    @employees = User.all.order(:first_name)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee_reviewer
      @employee_reviewer = EmployeeReviewer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_reviewer_params
      params.require(:employee_reviewer).permit(:employee_user_id, :reviewer_user_id)
    end
end
