class CreateEmployeeTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :employee_teams do |t|
      t.references :user, foreign_key: true
      t.boolean :team_lead
      t.boolean :supervisor

      t.timestamps
    end
  end
end
