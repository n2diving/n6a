class AddColumnsToUserReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :user_reviews, :checked, :boolean, default: false
    add_column :user_reviews, :multiplier, :integer
  end
end
