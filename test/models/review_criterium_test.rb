require 'test_helper'

class ReviewCriteriaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: review_criteria
#
#  id            :integer          not null, primary key
#  name          :string
#  scale_min     :integer
#  scale_max     :integer
#  start_date    :datetime
#  end_date      :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  notes_allowed :boolean          default(FALSE)
#
