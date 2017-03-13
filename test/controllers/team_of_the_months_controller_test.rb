require 'test_helper'

class TeamOfTheMonthsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @team_of_the_month = team_of_the_months(:one)
  end

  test "should get index" do
    get team_of_the_months_url
    assert_response :success
  end

  test "should get new" do
    get new_team_of_the_month_url
    assert_response :success
  end

  test "should create team_of_the_month" do
    assert_difference('TeamOfTheMonth.count') do
      post team_of_the_months_url, params: { team_of_the_month: { name: @team_of_the_month.name, rate_period: @team_of_the_month.rate_period } }
    end

    assert_redirected_to team_of_the_month_url(TeamOfTheMonth.last)
  end

  test "should show team_of_the_month" do
    get team_of_the_month_url(@team_of_the_month)
    assert_response :success
  end

  test "should get edit" do
    get edit_team_of_the_month_url(@team_of_the_month)
    assert_response :success
  end

  test "should update team_of_the_month" do
    patch team_of_the_month_url(@team_of_the_month), params: { team_of_the_month: { name: @team_of_the_month.name, rate_period: @team_of_the_month.rate_period } }
    assert_redirected_to team_of_the_month_url(@team_of_the_month)
  end

  test "should destroy team_of_the_month" do
    assert_difference('TeamOfTheMonth.count', -1) do
      delete team_of_the_month_url(@team_of_the_month)
    end

    assert_redirected_to team_of_the_months_url
  end
end
