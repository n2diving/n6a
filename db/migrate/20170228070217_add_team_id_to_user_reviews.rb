class AddTeamIdToUserReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :user_reviews, :team_id, :integer
  end
end
