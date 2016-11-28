class DropReviewCriteria < ActiveRecord::Migration[5.0]
  def up
    if ActiveRecord::Base.connection.table_exists? :review_criteria
      # remove_foreign_key :user_review, name: "review_criteria_id"
      drop_table :review_criteria, force: :cascade
    end
  end
  def down

  end
end
