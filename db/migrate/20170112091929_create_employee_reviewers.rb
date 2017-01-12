class CreateEmployeeReviewers < ActiveRecord::Migration[5.0]
  def change
    create_table :employee_reviewers do |t|
      t.integer :employee_user_id
      t.integer :reviewer_user_id

      t.timestamps
    end
  end
end
