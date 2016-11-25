class AddReviewableToReviewCriteria < ActiveRecord::Migration[5.0]
  def change
    add_column :review_criteria, :notes_allowed, :boolean, default: false
  end
end
