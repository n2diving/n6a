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
  has_many :user_reviews, through: :users

  scope :without_ab_operations, -> { where.not(team_name: ["teamA", "TeamB", "Operations"]) }


  def team_lead
    User.where(id: self.employee_teams.where(team_lead: true).first.try(:user_id)).first.try(:id)
  end

  def team_average_by_period(rate_period)
    teammates = self.user_reviews.pluck(:user_id).uniq

    list = UserReview.where(rate_period: rate_period).where.not(rating: nil)
    ratings = []
    teammates.each do |one_teammate_id|
      list.where(user_id: one_teammate_id).each do |one_user_review|
        ratings << one_user_review.rating
      end
    end
    p ratings
    (ratings.reduce(&:+) / ratings.count) if !ratings.blank?
  end

  def team_average_by_rate_item(rate_item_id, rate_period)
    teammates = EmployeeTeam.where(team_id: self.id).pluck(:user_id)

    list = UserReview.where(rate_item_id: rate_item_id, rate_period: rate_period).where.not(rating: nil)
    ratings = []
    teammates.each do |one_teammate|
      list.where(user_id: one_teammate).each do |one_user_review|
        ratings << one_user_review.rating
      end
    end
    (ratings.reduce(&:+) / ratings.count) if !ratings.blank?
  end

  def teammates_by_month(date)
    list = EmployeeTeam.where(team_id: self.id)
    users = nil

    if list.count > 1
      list_1 = list.where(end_date: nil).where('start_date > ?', date).pluck(:user_id)
      list_2 = list.where('? BETWEEN start_date AND end_date', date).pluck(:user_id)

      current_teammates = nil
      if list_2.blank?
        current_teammates = list_1
      else
        current_teammates = list_2
      end

      users = User.where(id: current_teammates)
    else
      users = User.where(id: list.pluck(:user_id))
    end

    users

  end

end