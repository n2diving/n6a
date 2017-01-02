require 'test_helper'

class ReviewItemsByRolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @review_items_by_role = review_items_by_roles(:one)
  end

  test "should get index" do
    get review_items_by_roles_url
    assert_response :success
  end

  test "should get new" do
    get new_review_items_by_role_url
    assert_response :success
  end

  test "should create review_items_by_role" do
    assert_difference('ReviewItemsByRole.count') do
      post review_items_by_roles_url, params: { review_items_by_role: {  } }
    end

    assert_redirected_to review_items_by_role_url(ReviewItemsByRole.last)
  end

  test "should show review_items_by_role" do
    get review_items_by_role_url(@review_items_by_role)
    assert_response :success
  end

  test "should get edit" do
    get edit_review_items_by_role_url(@review_items_by_role)
    assert_response :success
  end

  test "should update review_items_by_role" do
    patch review_items_by_role_url(@review_items_by_role), params: { review_items_by_role: {  } }
    assert_redirected_to review_items_by_role_url(@review_items_by_role)
  end

  test "should destroy review_items_by_role" do
    assert_difference('ReviewItemsByRole.count', -1) do
      delete review_items_by_role_url(@review_items_by_role)
    end

    assert_redirected_to review_items_by_roles_url
  end
end
