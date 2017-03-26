class AddIsHiddenToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :is_hidden, :boolean
  end
end
