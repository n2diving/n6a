# == Schema Information
#
# Table name: review_criteria
#
#  id                  :integer          not null, primary key
#  name                :string
#  scale_min           :integer
#  scale_max           :integer
#  start_date          :datetime
#  end_date            :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  notes_allowed       :boolean          default(FALSE)
#  short_name          :string
#  evaluation_criteria :text
#

class ReviewCriterium < ApplicationRecord
  has_many :user_reviews

  def scale
    self.scale_min.to_s + ' - ' + self.scale_max.to_s
  end
end
