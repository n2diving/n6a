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
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
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

  accepts_nested_attributes_for :user_reviews
  #, reject_if: proc { |a| a["notes"].blank? && a["pros"].blank? }


  def full_name
    return self.first_name.downcase + ' ' + self.last_name.downcase
  end

  def team_user_review_rows(columns, rate_period)
    @review_rows = {}
    columns.each_with_index do |one_column, i|
      user_review = UserReview.all.where(review_item_id: one_column[1], user_id: self.id, rate_period: rate_period.end_of_month).first
      @review_rows[i] = []
      @review_rows[i] << (user_review.nil? ? '' : user_review.rating)
    end
    @review_rows
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

end
