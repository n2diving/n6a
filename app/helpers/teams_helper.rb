module TeamsHelper
  def team_review_chart_results(user_reviews)
    @results = []
    list = user_reviews.pluck(:review_item_id).uniq
    list.each do |one_review_item_id|
      dataset = []
      name = nil
      user_reviews.where(review_item_id: one_review_item_id).where.not(rating: nil).each do |one_review|
        name = one_review.review_item.display_name
        dataset << [one_review.rate_period.strftime("%B %Y"), one_review.rating]
      end
      @results << { name: name, data: dataset }
    end
    @results.sort_by! { |results| results[:name] }
  end

  def team_review_other_teams_chart_results
    @results = []
    rate_periods = UserReview.all.pluck(:rate_period).uniq.sort
    @teams = Team.all


    @teams.each do |one_team|
      dataset = []
      rate_periods.each do |one_period|

        rating_list = UserReview.where(user_id: [one_team.users.pluck(:id)], rate_period: one_period).where.not(rating: nil).pluck(:rating)
        if rating_list.empty? || (rating_list == [nil])
          results = nil
        else
          results = (rating_list.reduce(&:+) / rating_list.count)
        end
        dataset << [one_period.strftime("%B %Y"), results ]
      end
      @results << { name: one_team.team_name, data: dataset }
    end
    @results.sort_by! { |results| results[:name] }
  end

  def teammates(team_id)
    user_ids = EmployeeTeam.where(team_id: team_id).pluck(:user_id)
    User.where(id: [user_ids])
  end

  def team_averages(team_id, rate_period_start, rate_period_end)
    # raise

    review_list = UserReview.where('rate_period BETWEEN ? and ? OR rate_period = ? OR rate_period = ?', rate_period_start, rate_period_end, rate_period_start, rate_period_end).where.not(rating: nil).joins(user: { employee_teams: :team }).where('employee_teams.team_id = ?', team_id)

    review_list.blank? ? 0 : (review_list.sum(:rating) / review_list.count.to_f).round(2)
  end

end
