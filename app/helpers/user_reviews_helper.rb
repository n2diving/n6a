module UserReviewsHelper

  def options_for_rate_period
    start_month = (Date.today + 2.months).end_of_month
    options = []
    i = 0
    12.times do
      one_month = (start_month - i.months).end_of_month
      options << [one_month.strftime("%B %Y"), one_month]
      i += 1
    end
    options
  end


end