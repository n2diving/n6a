class AddTeamtoEmployeeTeams < ActiveRecord::Migration[5.0]
  def change
    add_reference :employee_teams, :team, index: true
    add_foreign_key :employee_teams, :teams
  end
end