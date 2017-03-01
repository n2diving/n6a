# == Schema Information
#
# Table name: user_reviews
#
#  id                      :integer          not null, primary key
#  review_item_id          :integer
#  user_id                 :integer
#  rating                  :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  rated_by_user_id        :integer
#  notes_allowed           :boolean          default(FALSE)
#  rate_period             :date
#  is_team                 :boolean          default(FALSE)
#  pros                    :text
#  cons                    :text
#  notes                   :text
#  review_items_by_role_id :integer
#  is_archived             :boolean          default(FALSE)
#  checked                 :boolean          default(FALSE)
#  multiplier              :integer
#  team_id                 :integer
#
# Indexes
#
#  index_user_reviews_on_review_item_id           (review_item_id)
#  index_user_reviews_on_review_items_by_role_id  (review_items_by_role_id)
#  index_user_reviews_on_user_id                  (user_id)
#
# Foreign Keys
#
#  fk_rails_0c521cfb5d  (review_items_by_role_id => review_items_by_roles.id)
#  fk_rails_f526f8a17a  (user_id => users.id)
#

class UserReview < ApplicationRecord
  belongs_to :review_item
  belongs_to :review_items_by_role
  belongs_to :user
  has_one :review_note

  accepts_nested_attributes_for :review_note

  default_scope { where(is_archived: false) }

  # validates_uniqueness_of :rate_period, { scope: [ :user_id, :review_item_id ], message: "-- review has already been scored for this month." }
  before_save :normalize_date
  after_save :overwrite_reviews
  # after_create :employee_team_reviews


  def normalize_date
    # if self.review_item.is_weekly
    #   self.rate_period = self.rate_period.end_of_week
    # else
      self.rate_period = self.rate_period.end_of_month
    # end
  end

  def user_review_rows(columns, user_id, rate_period)
    @review_rows = {}
    columns.each_with_index do |one_column, i|
      user_review = UserReview.all.where(review_item_id: one_column[1], user_id: user_id, rate_period: rate_period.end_of_month).first
      @review_rows[i] = []
      @review_rows[i] << { rating: (user_review.nil? ? '' : user_review.rating) }
      @review_rows[i] << { notes: (user_review.nil? ? '' : user_review.combined_notes) }
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

  def combined_notes
    notes = {}
    notes[:pros] = self.pros unless self.pros.nil?
    notes[:cons] = self.cons unless self.cons.nil?
    notes[:notes] = self.notes unless self.notes.nil?
    results = ''
    notes.each_with_index do |(key,value),i|
      results << "<div class='text-left'><strong>#{key.upcase}:</strong> #{value}<br></div>"
      results << "<br>" if (key != notes.keys.last)
    end
    results
  end

  def overwrite_reviews
    user_id = self.user_id
    rate_period = self.rate_period
    review_item = self.review_item_id

    UserReview.where(user_id: user_id, rate_period: rate_period, review_item_id: review_item).where.not(id: self.id).each do |one_record|
      ReviewNote.where(user_review_id: one_record.id).try(:destroy_all)
      one_record.delete
    end
  end

  def weekly_review_item
    self.review_item.is_weekly == true
  end

  def review_noted

    team = EmployeeTeam.where(user_id: self.user_id).first.team
    user_ids = EmployeeTeam.where(team_id: team.id).pluck(:user_id)

    ReviewNote.all.joins(user_review: :review_item).where('user_reviews.user_id in (?)', user_ids).where('review_items.id = ?', self.review_item_id).last.try(:general_notes)


    # review_ids = UserReview.where(rate_period: self.rate_period, id: user_ids).pluck(:id)
    # ReviewNote.where(user_review_id: review_ids).first.try(:general_notes)
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
