# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  team_name  :string
#  start_date :datetime
#  end_date   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Team < ApplicationRecord
  has_many :employee_teams
  has_many :users, through: :employee_teams
  # , dependent: destroy

  def team_lead
    User.find(self.employee_teams.where(team_lead: true).first.user_id)
  end

end