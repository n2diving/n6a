class CreateTeamOfTheMonths < ActiveRecord::Migration[5.0]
  def change
    unless ActiveRecord::Base.connection.table_exists? 'team_of_the_months'
      create_table :team_of_the_months do |t|
        t.string :name
        t.date :rate_period

        t.timestamps
      end
    end
  end
end
