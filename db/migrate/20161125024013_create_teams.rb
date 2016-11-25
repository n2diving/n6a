class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :team_name
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
