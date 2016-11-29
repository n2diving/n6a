class AddDefaultsToEmployeeTeams < ActiveRecord::Migration[5.0]
  def change
    change_column :employee_teams, :team_lead, :boolean, default: false
  end
end
