class CreateFormRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :form_roles do |t|
      t.string :role
      t.string :abbreviation

      t.timestamps
    end
    add_reference :review_items_by_roles, :form_role, foreign_key: true
  end
end
