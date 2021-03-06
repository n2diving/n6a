module UsersHelper

  def review_chart_results(user_reviews)
    @results = []
    list = user_reviews.pluck(:review_item_id).uniq

    list.each do |one_review_item_id|
      dataset = []
      name = nil
      reviews = user_reviews.where(review_item_id: one_review_item_id).where.not(rating: nil)
      if reviews.any?
        reviews.each do |one_review|
          name = one_review.review_item.display_name
          dataset << [one_review.rate_period.strftime("%B %Y"), one_review.rating.nil? ? '0.00' : ('%.2f' % one_review.rating)]
        end
        @results << { name: name, data: dataset }
      end
    end
    @results.sort_by { |results| results[:name] }
  end

  def review_team_chart_results(user)
    team = user.current_team
    rate_periods = UserReview.all.pluck(:rate_period).uniq.sort

    team_dataset = []
    employee_dataset = []

    unless rate_periods.nil? || team.nil?
      rate_periods.each do |one_period|
        employee_ratings = UserReview.where(user_id: user.id, rate_period: one_period).where.not(rating: nil).pluck(:rating)
        unless employee_ratings.blank?
          employee_dataset << [one_period.strftime("%B %Y"), ('%.2f' % (employee_ratings.reduce(&:+) / employee_ratings.count))]
          team_dataset << [one_period.strftime("%B %Y"), ('%.2f' % (user.team_average(team, one_period)))]
        end


      end

      unless (team_dataset.empty? && employee_dataset.empty?)
        @results = [
          {
            name: "employee",
            data: employee_dataset
          },
          {
            name: "group",
            data: team_dataset
          }]
      end
    end
  end

end