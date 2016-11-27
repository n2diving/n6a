class AddIsTeamToUserReview < ActiveRecord::Migration[5.0]
  def change
    add_column :user_reviews, :is_team, :boolean, default: false
  end
end