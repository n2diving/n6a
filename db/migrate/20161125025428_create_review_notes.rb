class CreateReviewNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :review_notes do |t|
      t.references :user_review, foreign_key: true
      t.text :general_notes
      t.text :pros
      t.text :cons

      t.timestamps
    end
  end
end
