class AddFieldsToUserReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :user_reviews, :pros, :text
    add_column :user_reviews, :cons, :text
  end
end
