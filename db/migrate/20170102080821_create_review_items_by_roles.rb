class CreateReviewItemsByRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :review_items_by_roles do |t|
      t.references :review_item, foreign_key: true
      t.string :short_label
      t.text :evaluation_criteria

    end
  end
end