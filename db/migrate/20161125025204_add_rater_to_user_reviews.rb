class AddRaterToUserReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :user_reviews, :rated_by_user_id, :integer
    add_column :user_reviews, :notes_allowed, :boolean, default: false
  end
end
