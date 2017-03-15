class ChangeIntegerToFloatUserReviews < ActiveRecord::Migration[5.0]
  def up
    change_column :user_reviews, :rating, :decimal, precision: 3, scale: 1
  end

  def down
    change_column :user_reviews, :rating, :integer
  end
end
