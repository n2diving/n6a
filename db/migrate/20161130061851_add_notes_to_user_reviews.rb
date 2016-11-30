class AddNotesToUserReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :user_reviews, :notes, :text
  end
end
