module UsersHelper

  def review_chart_results(user_reviews)
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

  def review_team_chart_results(user)
    team = user.teams.first
    rate_periods = UserReview.all.pluck(:rate_period).uniq.sort

    team_dataset = []
    employee_dataset = []

    rate_periods.each do |one_period|
      employee_ratings = UserReview.where(user_id: user.id, rate_period: one_period).where.not(rating: nil).pluck(:rating)
      unless employee_ratings.blank?
        employee_dataset << [one_period.strftime("%B %Y"), (employee_ratings.reduce(&:+) / employee_ratings.count)]
      end

      team_dataset << [one_period.strftime("%B %Y"), user.team_average(team, one_period)]
    end

    @results = [
      {
        name: "employee",
        data: employee_dataset
      },
      {
        name: "team",
        data: team_dataset
      }]
  end

end