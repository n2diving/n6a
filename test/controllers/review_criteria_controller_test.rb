require 'test_helper'

class ReviewCriteriaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @review_criteria = review_criteria(:one)
  end

  test "should get index" do
    get review_criteria_url
    assert_response :success
  end

  test "should get new" do
    get new_review_criteria_url
    assert_response :success
  end

  test "should create review_criteria" do
    assert_difference('ReviewCriteria.count') do
      post review_criteria_url, params: { review_criteria: { end_date: @review_criteria.end_date, name: @review_criteria.name, scale: @review_criteria.scale, start_date: @review_criteria.start_date } }
    end

    assert_redirected_to review_criteria_url(ReviewCriteria.last)
  end

  test "should show review_criteria" do
    get review_criteria_url(@review_criteria)
    assert_response :success
  end

  test "should get edit" do
    get edit_review_criteria_url(@review_criteria)
    assert_response :success
  end

  test "should update review_criteria" do
    patch review_criteria_url(@review_criteria), params: { review_criteria: { end_date: @review_criteria.end_date, name: @review_criteria.name, scale: @review_criteria.scale, start_date: @review_criteria.start_date } }
    assert_redirected_to review_criteria_url(@review_criteria)
  end

  test "should destroy review_criteria" do
    assert_difference('ReviewCriteria.count', -1) do
      delete review_criteria_url(@review_criteria)
    end

    assert_redirected_to review_criteria_url
  end
end
