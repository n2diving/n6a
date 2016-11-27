# == Schema Information
#
# Table name: user_reviews
#
#  id                 :integer          not null, primary key
#  review_criteria_id :integer
#  user_id            :integer
#  rating             :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  rated_by_user_id   :integer
#  notes_allowed      :boolean          default(FALSE)
#  rate_period        :date
#
# Indexes
#
#  index_user_reviews_on_review_criteria_id  (review_criteria_id)
#  index_user_reviews_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_f0ae0700b1  (review_criteria_id => review_criteria.id)
#  fk_rails_f526f8a17a  (user_id => users.id)
#

class UserReview < ApplicationRecord
  belongs_to :review_criteria
  belongs_to :user
end
