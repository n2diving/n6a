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
    rate_periods = UserReview.all.pluck(:rate_period).uniq.sort

    @results = []
    unless rate_periods.nil?
      dataset = []
      name = nil
      Team.all.each do |one_team|
        rate_periods.each do |one_review_period|
          name = one_team.team_name
          dataset << [one_review_period.strftime("%B %Y"), one_team.team_average_by_period(one_review_period)]
        end
        @results << { name: name, data: dataset }
      end
      @results.sort_by! { |results| results[:name] }
    end
    @results
  end
end
