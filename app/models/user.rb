# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  start_date             :datetime
#  is_current             :boolean          default(TRUE)
#  title                  :string
#  first_name             :string
#  last_name              :string
#  is_officer             :boolean          default(FALSE)
#  is_admin               :boolean          default(FALSE)
#  form_role_id           :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_form_role_id          (form_role_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_030672cb6e  (form_role_id => form_roles.id)
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  # :registerable,

  has_many :user_reviews
  has_many :employee_teams
  has_many :teams, through: :employee_teams, dependent: :destroy
  has_one :form_role

  has_many :employee_reviewers, foreign_key: :from_user_id, class_name: "EmployeeReviewer"
  has_many :reviewers, through: :employee_reviewers, source: :reviewer

  has_many :reviewed_employees, foreign_key: :to_user_id, class_name: "EmployeeReviewer"
  has_many :employees, through: :reviewed_employees, source: :employee

  accepts_nested_attributes_for :user_reviews
  #, reject_if: proc { |a| a["notes"].blank? && a["pros"].blank? }

  default_scope { order(first_name: :asc) }
  scope :without_admin, -> { where.not(id: [1, 6, 41, 48, 39, 38]) }
  scope :current, -> { where(is_current: true) }



  def full_name
    return self.first_name.capitalize + ' ' + self.last_name.capitalize
  end

  def team_user_review_rows(columns, rate_period, team_id)
    @review_rows = {}
    columns.each_with_index do |one_column, i|
      user_review = UserReview.all.where(review_item_id: one_column[1], user_id: self.id, rate_period: rate_period.end_of_month, team_id: team_id).first
      @review_rows[i] = []
      @review_rows[i] << { rating: (user_review.nil? ? '' : (user_review.rating.nil? ? '' : ('%.1f' % user_review.rating))) }
      @review_rows[i] << { notes:(user_review.nil? ? '' : user_review.combined_notes) }
    end
    @review_rows
  end

  def bonus_totals(user_reviews, rate_period, team_id)
    list = user_reviews.where(rate_period: rate_period, checked: true, team_id: team_id)
    bonus_amount = []

    list.each do |one|
      if !one.review_item.bonus_amount.nil?
        if one.multiplier.nil?
          bonus_amount << one.review_item.bonus_amount
        else
          bonus_amount << (one.review_item.bonus_amount * one.multiplier)
        end
      end
    end
    bonus_amount.sum

  end

  def team_average(team, rate_period)
    teammates = EmployeeTeam.where(team_id: team.id).pluck(:user_id)

    list = UserReview.where(rate_period: rate_period).where.not(rating: nil)
    ratings = []
    teammates.each do |one_teammate|
      list.where(user_id: one_teammate).each do |one_user_review|
        ratings << one_user_review.rating
      end
    end
    (ratings.reduce(&:+) / ratings.count) if !ratings.blank?
  end

  def can_review_users
    User.where(id: EmployeeReviewer.where(reviewer_user_id: self.id).pluck(:employee_user_id))
  end

  def can_review_user(user_id)
    EmployeeReviewer.where(reviewer_user_id: self.id, employee_user_id: user_id).any?
  end

  def current_team
    EmployeeTeam.where(user_id: self.id).where(end_date: nil).where('? >= start_date', Date.today).first.try(:team)
  end

  def month_team(date)

    list = EmployeeTeam.where(user_id: self.id)
    team = nil

    if list.count > 1
      list_1 = list.where(end_date: nil).where('start_date < ?', date).pluck(:team_id)
      list_2 = list.where('? BETWEEN start_date AND end_date', date).pluck(:team_id)

      current_team = nil
      if list_2.blank?
        current_team = list_1
      else
        current_team = list_2
      end

      team = Team.where(id: current_team.first).first
    else
      team = Team.where(id: list.first.try(:team_id)).first
    end

    team

  end

end
