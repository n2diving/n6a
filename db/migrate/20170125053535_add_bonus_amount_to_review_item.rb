class AddBonusAmountToReviewItem < ActiveRecord::Migration[5.0]
  def change
    add_column :review_items, :bonus_amount, :float
  end
end
