class TeamOfTheMonth < ApplicationRecord

  before_save :normalize_date

  def normalize_date
    self.rate_period = self.rate_period.end_of_month
  end

end

# == Schema Information
#
# Table name: team_of_the_months
#
#  id          :integer          not null, primary key
#  name        :string
#  rate_period :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
