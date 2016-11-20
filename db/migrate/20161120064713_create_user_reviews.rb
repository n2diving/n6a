class CreateUserReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :user_reviews do |t|
      t.references :review_criteria, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :rating

      t.timestamps
    end
  end
end
