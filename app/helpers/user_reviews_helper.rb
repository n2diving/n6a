module UserReviewsHelper

  def options_for_rate_period
    this_month = ((Date.today.day) < 10 ? (Date.today.month - 1) : Date.today.month)

    options = []
    Date::MONTHNAMES.each_with_index do |one_month, i|
      if i <= this_month && !one_month.nil?
        options << [one_month.to_date.end_of_month.strftime("%B %Y"), one_month.to_date.end_of_month]
      end
    end
    options
  end

  def bonus_totals(user_reviews)
    @bonus_amount = []

    list = user_reviews.where(checked: true)

    list.each do |one|
      if !one.review_item.bonus_amount.nil?
        if one.multiplier.nil?
          @bonus_amount << one.review_item.bonus_amount
        else
          @bonus_amount << (one.review_item.bonus_amount * one.multiplier)
        end
      end
    end
    @bonus_amount

  end

end