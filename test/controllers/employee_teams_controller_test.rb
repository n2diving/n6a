require 'test_helper'

class EmployeeTeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee_team = employee_teams(:one)
  end

  test "should get index" do
    get employee_teams_url
    assert_response :success
  end

  test "should get new" do
    get new_employee_team_url
    assert_response :success
  end

  test "should create employee_team" do
    assert_difference('EmployeeTeam.count') do
      post employee_teams_url, params: { employee_team: { supervisor: @employee_team.supervisor, team_lead: @employee_team.team_lead, user_id: @employee_team.user_id } }
    end

    assert_redirected_to employee_team_url(EmployeeTeam.last)
  end

  test "should show employee_team" do
    get employee_team_url(@employee_team)
    assert_response :success
  end

  test "should get edit" do
    get edit_employee_team_url(@employee_team)
    assert_response :success
  end

  test "should update employee_team" do
    patch employee_team_url(@employee_team), params: { employee_team: { supervisor: @employee_team.supervisor, team_lead: @employee_team.team_lead, user_id: @employee_team.user_id } }
    assert_redirected_to employee_team_url(@employee_team)
  end

  test "should destroy employee_team" do
    assert_difference('EmployeeTeam.count', -1) do
      delete employee_team_url(@employee_team)
    end

    assert_redirected_to employee_teams_url
  end
end
