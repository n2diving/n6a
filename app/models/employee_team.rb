# == Schema Information
#
# Table name: employee_teams
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  team_lead  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :integer
#  start_date :date
#  end_date   :date
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

  # validates_uniqueness_of :team_lead, { scope: :team_id }

  after_create :verify_end_date, :check_team_reviews

  def is_team_lead(user_id)
    self.where(user_id: user_id, team_lead: true).first
  end

  def verify_end_date
    results = EmployeeTeam.where(user_id: self.user_id)
    if results.count > 1
      ordered = results.order(start_date: :desc).where(end_date: nil)
      new_start = ordered.first.start_date
      new_end = new_start - 1.day
      ordered.each do |one|
        unless one.id == ordered.first.id
          one.end_date = new_end
          one.save
        end
      end
    end
  end

  def check_team_reviews
    month = self.start_date.end_of_month
    new_team_id = self.team_id
    user = self.user_id

    team_reviews = UserReview.where(team_id: new_team_id, rate_period: month, is_team: true)
    user_reviews = UserReview.where(rate_period: month, user_id: user)

    if user_reviews.any?
      user_reviews.each do |one_review|
        one_review.team_id = new_team_id
        one_review.save
      end
    end

    if team_reviews.any?
      team_reviews.each do |one_review|
        UserReview.create(
          review_item_id: one_review.review_item_id,
          user_id: user,
          rating: one_review.rating,
          rated_by_user_id: one_review.rated_by_user_id,
          notes_allowed: one_review.notes_allowed,
          rate_period: one_review.rate_period,
          is_team: one_review.is_team,
          pros: one_review.pros,
          cons: one_review.cons,
          notes: one_review.notes,
          review_items_by_role_id: one_review.review_items_by_role_id,
          checked: one_review.checked,
          multiplier: one_review.multiplier,
          team_id: one_review.team_id
        )
      end
    else
      UserReview.where(user_id: user, rate_period: month, is_team: true).each do |one_review|
        one_review.is_archived = true
        one_review.save
      end

    end
  end

  def current_employee_team(user_id)
    EmployeeTeam.where(user_id: user_id).where('? BETWEEN start_date AND end_date', Date.today).first.team
  end
end
