class AddDateToUserReview < ActiveRecord::Migration[5.0]
  def change
    add_column :user_reviews, :rate_period, :date
  end
end
