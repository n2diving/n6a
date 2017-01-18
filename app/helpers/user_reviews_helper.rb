module UserReviewsHelper

  def options_for_rate_period
    this_month = Date.today.month

    options = []
    Date::MONTHNAMES.each_with_index do |one_month, i|
      if i <= this_month && !one_month.nil?
        options << [one_month.to_date.strftime("%B %Y"), one_month]
      end
    end
    options
  end

end