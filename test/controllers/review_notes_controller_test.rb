require 'test_helper'

class ReviewNotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @review_note = review_notes(:one)
  end

  test "should get index" do
    get review_notes_url
    assert_response :success
  end

  test "should get new" do
    get new_review_note_url
    assert_response :success
  end

  test "should create review_note" do
    assert_difference('ReviewNote.count') do
      post review_notes_url, params: { review_note: { cons: @review_note.cons, general_notes: @review_note.general_notes, pros: @review_note.pros, user_review_id: @review_note.user_review_id } }
    end

    assert_redirected_to review_note_url(ReviewNote.last)
  end

  test "should show review_note" do
    get review_note_url(@review_note)
    assert_response :success
  end

  test "should get edit" do
    get edit_review_note_url(@review_note)
    assert_response :success
  end

  test "should update review_note" do
    patch review_note_url(@review_note), params: { review_note: { cons: @review_note.cons, general_notes: @review_note.general_notes, pros: @review_note.pros, user_review_id: @review_note.user_review_id } }
    assert_redirected_to review_note_url(@review_note)
  end

  test "should destroy review_note" do
    assert_difference('ReviewNote.count', -1) do
      delete review_note_url(@review_note)
    end

    assert_redirected_to review_notes_url
  end
end
