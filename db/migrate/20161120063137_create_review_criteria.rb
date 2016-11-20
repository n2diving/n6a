class CreateReviewCriteria < ActiveRecord::Migration[5.0]
  def change
    create_table :review_criteria do |t|
      t.string :name
      t.integer :scale_min
      t.integer :scale_max
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
