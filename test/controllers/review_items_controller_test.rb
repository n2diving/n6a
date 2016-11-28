require 'test_helper'

class ReviewItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @review_item = review_items(:one)
  end

  test "should get index" do
    get review_items_url
    assert_response :success
  end

  test "should get new" do
    get new_review_item_url
    assert_response :success
  end

  test "should create review_item" do
    assert_difference('ReviewItem.count') do
      post review_items_url, params: { review_item: { display_name: @review_item.display_name, evaluation_criteria: @review_item.evaluation_criteria, name: @review_item.name, response_allowed: @review_item.response_allowed, scale_max: @review_item.scale_max, scale_min: @review_item.scale_min, start_date: @review_item.start_date } }
    end

    assert_redirected_to review_item_url(ReviewItem.last)
  end

  test "should show review_item" do
    get review_item_url(@review_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_review_item_url(@review_item)
    assert_response :success
  end

  test "should update review_item" do
    patch review_item_url(@review_item), params: { review_item: { display_name: @review_item.display_name, evaluation_criteria: @review_item.evaluation_criteria, name: @review_item.name, response_allowed: @review_item.response_allowed, scale_max: @review_item.scale_max, scale_min: @review_item.scale_min, start_date: @review_item.start_date } }
    assert_redirected_to review_item_url(@review_item)
  end

  test "should destroy review_item" do
    assert_difference('ReviewItem.count', -1) do
      delete review_item_url(@review_item)
    end

    assert_redirected_to review_items_url
  end
end
