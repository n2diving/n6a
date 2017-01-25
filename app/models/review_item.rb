class ReviewItem < ApplicationRecord
  has_many :user_reviews
  has_many :review_items_by_roles

  def scale
    self.scale_min.to_s + ' - ' + self.scale_max.to_s
  end
end

# == Schema Information
#
# Table name: review_items
#
#  id                  :integer          not null, primary key
#  name                :string
#  display_name        :string
#  evaluation_criteria :text
#  scale_min           :integer
#  scale_max           :integer
#  start_date          :date
#  end_date            :date
#  response_allowed    :boolean          default(FALSE)
#  is_team             :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  is_weekly           :boolean          default(FALSE)
#  is_monthly_bonus    :boolean          default(FALSE)
#  bonus_amount        :float
#
