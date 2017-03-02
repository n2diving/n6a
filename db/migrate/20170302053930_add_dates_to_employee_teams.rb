class AddDatesToEmployeeTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :employee_teams, :start_date, :date
    add_column :employee_teams, :end_date, :date
  end
end
