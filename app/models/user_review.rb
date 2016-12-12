# == Schema Information
#
# Table name: user_reviews
#
#  id               :integer          not null, primary key
#  review_item_id   :integer
#  user_id          :integer
#  rating           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  rated_by_user_id :integer
#  notes_allowed    :boolean          default(FALSE)
#  rate_period      :date
#  is_team          :boolean          default(FALSE)
#  pros             :text
#  cons             :text
#  notes            :text
#
# Indexes
#
#  index_user_reviews_on_review_item_id  (review_item_id)
#  index_user_reviews_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_f526f8a17a  (user_id => users.id)
#

class UserReview < ApplicationRecord
  belongs_to :review_item
  belongs_to :user
  has_one :review_note

  validates_uniqueness_of :rate_period, { scope: [ :user_id, :review_item_id ], message: "-- review has already been scored for this month." }
  before_save :normalize_date
  # after_create :employee_team_reviews


  def normalize_date
    if self.review_item.is_weekly
      self.rate_period = self.rate_period.end_of_week
    else
      self.rate_period = self.rate_period.end_of_month
    end
  end

  def user_review_rows(columns, user_id, rate_period)
    @review_rows = {}
    columns.each_with_index do |one_column, i|
      user_review = UserReview.all.where(review_item_id: one_column[1], user_id: user_id, rate_period: rate_period.end_of_month).first
      @review_rows[i] = []
      @review_rows[i] << (user_review.nil? ? '' : user_review.rating)
      # @review_rows[i] << (user_review.nil? ? '' : ( sprintf.try("%.2f", user_review.rating) ))
    end
    @review_rows
  end

  def team_review_rows(columns, team_id, rate_period)
    @review_rows = {}
    team = Team.find(team_id)
    teammates = team.users.pluck(:id)

    columns.each_with_index do |one_column, i|
      user_review = UserReview.all.where(review_item_id: one_column[1], user_id: teammates, rate_period: rate_period.end_of_month)


      @review_rows[i] = []
      @review_rows[i] << (user_review.blank? ? 0 : ('%.2f' % (user_review.sum(:rating) / user_review.count.to_f).round(2)))
    end
    @review_rows
  end

  # def employee_team_reviews
  #   if (self.review_item.is_team == true)
  #     team = self.user.teams.first
  #     teammates = EmployeeTeam.where(team_id: team.id).where.not(user_id: self.user_id)
  #     teammates.each do |one_teammate_employee_team_record|
  #       user = User.find(one_teammate_employee_team_record.user_id)
  #       user_reviews = user.user_reviews.where(rate_period: self.rate_period, review_item_id: self.review_item_id)
  #       if user_reviews.blank?
  #         UserReview.create(
  #           revier_item_id: self.review_item_id,
  #           user_id: one_teammate_employee_team_record.user_id,
  #           rating: self.rating,
  #           rate_period: self.rate_period,
  #           is_team: true
  #         )
  #       end
  #     end
  #   end
  # end

end