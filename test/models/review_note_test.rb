require 'test_helper'

class ReviewNoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: review_notes
#
#  id             :integer          not null, primary key
#  user_review_id :integer
#  general_notes  :text
#  pros           :text
#  cons           :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_review_notes_on_user_review_id  (user_review_id)
#
# Foreign Keys
#
#  fk_rails_70e4e5b9dd  (user_review_id => user_reviews.id)
#
