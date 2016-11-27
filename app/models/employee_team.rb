# == Schema Information
#
# Table name: employee_teams
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  team_lead  :boolean
#  supervisor :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :integer
#
# Indexes
#
#  index_employee_teams_on_team_id  (team_id)
#  index_employee_teams_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_1b2a74894e  (user_id => users.id)
#  fk_rails_26b83f11ef  (team_id => teams.id)
#

class EmployeeTeam < ApplicationRecord
  belongs_to :user
  belongs_to :team
end
