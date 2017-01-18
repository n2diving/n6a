class AddIsArchivedToUserReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :user_reviews, :is_archived, :boolean, default: false
  end
end
