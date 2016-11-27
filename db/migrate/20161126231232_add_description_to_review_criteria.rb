class AddDescriptionToReviewCriteria < ActiveRecord::Migration[5.0]
  def change
    add_column :review_criteria, :short_name, :string
    add_column :review_criteria, :evaluation_criteria, :text
  end
end
