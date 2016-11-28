class ChangeReviewCriteriaOnUserReviews < ActiveRecord::Migration[5.0]
  def change
    rename_column :user_reviews, :review_criteria_id, :review_item_id
  end
end