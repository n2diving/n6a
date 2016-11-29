class RemoveIsSupervisorFromEmployeeTeams < ActiveRecord::Migration[5.0]
  def change
    remove_column :employee_teams, :supervisor
  end
end
