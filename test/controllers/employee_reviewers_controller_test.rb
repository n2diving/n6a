require 'test_helper'

class EmployeeReviewersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee_reviewer = employee_reviewers(:one)
  end

  test "should get index" do
    get employee_reviewers_url
    assert_response :success
  end

  test "should get new" do
    get new_employee_reviewer_url
    assert_response :success
  end

  test "should create employee_reviewer" do
    assert_difference('EmployeeReviewer.count') do
      post employee_reviewers_url, params: { employee_reviewer: { employee_user_id: @employee_reviewer.employee_user_id, reviewer_user_id: @employee_reviewer.reviewer_user_id } }
    end

    assert_redirected_to employee_reviewer_url(EmployeeReviewer.last)
  end

  test "should show employee_reviewer" do
    get employee_reviewer_url(@employee_reviewer)
    assert_response :success
  end

  test "should get edit" do
    get edit_employee_reviewer_url(@employee_reviewer)
    assert_response :success
  end

  test "should update employee_reviewer" do
    patch employee_reviewer_url(@employee_reviewer), params: { employee_reviewer: { employee_user_id: @employee_reviewer.employee_user_id, reviewer_user_id: @employee_reviewer.reviewer_user_id } }
    assert_redirected_to employee_reviewer_url(@employee_reviewer)
  end

  test "should destroy employee_reviewer" do
    assert_difference('EmployeeReviewer.count', -1) do
      delete employee_reviewer_url(@employee_reviewer)
    end

    assert_redirected_to employee_reviewers_url
  end
end
