require 'test_helper'

class ReviewCriteriaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @review_criterium = review_criteria(:one)
  end

  test "should get index" do
    get review_criteria_url
    assert_response :success
  end

  test "should get new" do
    get new_review_criterium_url
    assert_response :success
  end

  test "should create review_criterium" do
    assert_difference('ReviewCriterium.count') do
      post review_criteria_url, params: { review_criterium: { end_date: @review_criterium.end_date, name: @review_criterium.name, scale: @review_criterium.scale, start_date: @review_criterium.start_date } }
    end

    assert_redirected_to review_criterium_url(ReviewCriterium.last)
  end

  test "should show review_criterium" do
    get review_criterium_url(@review_criterium)
    assert_response :success
  end

  test "should get edit" do
    get edit_review_criterium_url(@review_criterium)
    assert_response :success
  end

  test "should update review_criterium" do
    patch review_criterium_url(@review_criterium), params: { review_criterium: { end_date: @review_criterium.end_date, name: @review_criterium.name, scale: @review_criterium.scale, start_date: @review_criterium.start_date } }
    assert_redirected_to review_criterium_url(@review_criterium)
  end

  test "should destroy review_criterium" do
    assert_difference('ReviewCriterium.count', -1) do
      delete review_criterium_url(@review_criterium)
    end

    assert_redirected_to review_criteria_url
  end
end
