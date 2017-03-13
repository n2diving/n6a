class CreateTeamOfTheMonths < ActiveRecord::Migration[5.0]
  def change
    create_table :team_of_the_months do |t|
      t.string :name
      t.date :rate_period

      t.timestamps
    end
  end
end
