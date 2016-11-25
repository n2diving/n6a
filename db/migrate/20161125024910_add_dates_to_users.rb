class AddDatesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :start_date, :datetime
    add_column :users, :is_current, :boolean, default: true
    add_column :users, :title, :string
  end
end
