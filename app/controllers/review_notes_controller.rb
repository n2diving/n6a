class ReviewNotesController < ApplicationController
  before_action :set_review_note, only: [:show, :edit, :update, :destroy]

  # GET /review_notes
  # GET /review_notes.json
  def index
    @review_notes = ReviewNote.all
  end

  # GET /review_notes/1
  # GET /review_notes/1.json
  def show
  end

  # GET /review_notes/new
  def new
    @review_note = ReviewNote.new
  end

  # GET /review_notes/1/edit
  def edit
  end

  # POST /review_notes
  # POST /review_notes.json
  def create
    @review_note = ReviewNote.new(review_note_params)

    respond_to do |format|
      if @review_note.save
        format.html { redirect_to @review_note, notice: 'Review note was successfully created.' }
        format.json { render :show, status: :created, location: @review_note }
      else
        format.html { render :new }
        format.json { render json: @review_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /review_notes/1
  # PATCH/PUT /review_notes/1.json
  def update
    respond_to do |format|
      if @review_note.update(review_note_params)
        format.html { redirect_to @review_note, notice: 'Review note was successfully updated.' }
        format.json { render :show, status: :ok, location: @review_note }
      else
        format.html { render :edit }
        format.json { render json: @review_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /review_notes/1
  # DELETE /review_notes/1.json
  def destroy
    @review_note.destroy
    respond_to do |format|
      format.html { redirect_to review_notes_url, notice: 'Review note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review_note
      @review_note = ReviewNote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_note_params
      params.require(:review_note).permit(:user_review_id, :general_notes, :pros, :cons)
    end
end
