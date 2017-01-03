class AddReviewItemsByRoleToUserReviews < ActiveRecord::Migration[5.0]
  def change
    add_reference :user_reviews, :review_items_by_role, foreign_key: true
  end
end
