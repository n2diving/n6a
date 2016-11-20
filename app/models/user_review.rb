class UserReview < ApplicationRecord
  belongs_to :review_criteria
  belongs_to :user
end
