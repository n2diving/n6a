class CreateReviewItems < ActiveRecord::Migration[5.0]
  def change
    create_table :review_items do |t|
      t.string :name
      t.string :display_name
      t.text :evaluation_criteria
      t.integer :scale_min
      t.integer :scale_max
      t.date :start_date
      t.date :end_date
      t.boolean :response_allowed, default: false
      t.boolean :is_team, default: false

      t.timestamps
    end
  end
end