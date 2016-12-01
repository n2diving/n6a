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

  # def team_review_other_teams_chart_results
  #   rate_periods = UserReview.all.pluck(:rate_period).uniq.sort
  #   @teams = Team.all
  #
  #   @results = []
  #   unless rate_periods.nil?
  #     dataset = []
  #     name = nil
  #     results = []
  #     @teams.each do |one_team|
  #       rate_periods.each do |one_review_period|
  #
  #         # rating_list = UserReview.where(user_id: [one_team.users.pluck(:id)], rate_period: one_review_period).where.not(rating: nil).pluck(:rating)
  #         # if rating_list.empty? || (rating_list == [nil])
  #         #   results = nil
  #         # else
  #         #   results = (rating_list.reduce(&:+) / rating_list.count)
  #         # end
  #
  #         results = [1,2,3,4]
  #
  #         dataset << [one_review_period.strftime("%B %Y"), results.sample ]
  #       end
  #         name = one_team.team_name
  #     end
  #       @results << { name: name, data: dataset }
  #   end
  #   # @results.sort_by! { |results| results[:name] }
  #   @results
  # end

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
end
