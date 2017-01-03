class AddFormRoleToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :form_role, foreign_key: true
  end
end
