module TeamsHelper
  include UserReviewsHelper

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

    rate_period_ending = rate_period_end.end_of_month

    review_list = UserReview.where('rate_period between ? AND ?', rate_period_ending, rate_period_start).where.not(rating: nil).where(team_id: team_id)

    # {rate_period: rate_period_start, rate_end: rate_period_end, list: review_list.pluck(:rate_period).uniq.sort, count: review_list.count }
    review_list.blank? ? 0 : ('%.2f' % ((review_list.sum(:rating) / review_list.count.to_f).round(2)))
  end

  def team_adjusted_averages(team_id, rate_period)
    reviews = UserReview.where(rate_period: rate_period, team_id: team_id)
    reviews.pluck(:user_id).each do |one_user|
      average = reviews.where(user_id: one_user).pluck(:rating)
      average.reject! {|x| x == nil}
      average.reject! {|x| x == 0}
      bonus = bonus_totals(reviews)

      totals = []
      unless average.blank?
        totals << ((average.reduce(:+) / average.size.to_f) + bonus.sum).round(2)
      end
    end

    totals.blank? ? 0 : ('%.2f' % (totals.reduce(:+)/totals.size.to_f))
  end

  def team_ranking(team_id, rate_period)
    @results = {}
    team_rank_index = nil
    Team.without_ab.each do |one_team|
      team_avg = team_averages(one_team.id, rate_period, rate_period).to_f
      bonus = bonus_totals(UserReview.where(rate_period: rate_period, team_id: one_team.id)).sum
      totals = (team_avg + bonus).zero? ? 0 : '%.2f' % (team_avg + bonus)
      @results["#{one_team.id}"] = totals
    end
    @results.sort_by {|k,v| v.to_f}.reverse.each_with_index { |(k,v),i| team_rank_index = i if (k == team_id.to_s) }
    team_rank_index + 1
  end

  def team_rank(rate_period)
    results = {}
    Team.without_ab.each do |one_team|
      results["#{one_team.id}"] = team_averages(one_team.id, rate_period, rate_period)
    end
    results = results.sort_by {|k,v| v.to_f}.reverse

    answer = results.first.first.to_i
  end

end
