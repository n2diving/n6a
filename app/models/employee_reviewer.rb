class EmployeeReviewer < ApplicationRecord

  belongs_to :employee, foreign_key: "employee_user_id", class_name: "User"
  belongs_to :reviewer, foreign_key: "reviewer_user_id",   class_name: "User"

  def reviewable_employees(user_id)
    User.where(id: EmployeeReviewer.where(reviewer_user_id: user_id).pluck(:employee_user_id))
  end
end

# == Schema Information
#
# Table name: employee_reviewers
#
#  id               :integer          not null, primary key
#  employee_user_id :integer
#  reviewer_user_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
