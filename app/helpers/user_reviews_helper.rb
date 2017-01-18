module UserReviewsHelper

  def options_for_rate_period
    this_month = Date.today.next_month.month

    options = []
    options << [Date.today.last_year.to_date.strftime("%B %Y"), Date.today]
    Date::MONTHNAMES.each_with_index do |one_month, i|
      if i <= this_month && !one_month.nil?
        options << [one_month.to_date.end_of_month.strftime("%B %Y"), one_month.to_date.end_of_month]
      end
    end

    options
  end

end