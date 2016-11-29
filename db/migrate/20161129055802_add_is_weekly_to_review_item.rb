class AddIsWeeklyToReviewItem < ActiveRecord::Migration[5.0]
  def change
    add_column :review_items, :is_weekly, :boolean, default: false
  end
end
