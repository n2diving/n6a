module ApplicationHelper
  def current_month
    (Date.today.day) < 10 ? ((Date.today - 1.month).end_of_month) : Date.today.end_of_month
  end
end