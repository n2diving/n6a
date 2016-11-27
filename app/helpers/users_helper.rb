module UsersHelper

  def review_chart_results(user_reviews)
    @results = []
    list = user_reviews.pluck(:review_criteria_id).uniq
    list.each do |one_review_criteria_id|
      dataset = []
      name = nil
      user_reviews.where(review_criteria_id: one_review_criteria_id).each do |one_review|
        name = one_review.review_criteria.short_name
        dataset << [one_review.rate_period.strftime("%B %Y"), one_review.rating]
      end
        @results << { name: name, data: dataset }
    end
    @results.sort_by! { |results| results[:name] }
  end
end