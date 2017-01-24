class AddIsMonthlyBonusToReviewItems < ActiveRecord::Migration[5.0]
  def change
    add_column :review_items, :is_monthly_bonus, :boolean, default: false
  end
end
