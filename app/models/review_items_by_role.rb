class ReviewItemsByRole < ApplicationRecord
  belongs_to :form_role
  belongs_to :review_item
  has_many :user_reviews
end

# == Schema Information
#
# Table name: review_items_by_roles
#
#  id                  :integer          not null, primary key
#  review_item_id      :integer
#  short_label         :string
#  evaluation_criteria :text
#  form_role_id        :integer
#
# Indexes
#
#  index_review_items_by_roles_on_form_role_id    (form_role_id)
#  index_review_items_by_roles_on_review_item_id  (review_item_id)
#
# Foreign Keys
#
#  fk_rails_93fd33afad  (form_role_id => form_roles.id)
#  fk_rails_b13f740d99  (review_item_id => review_items.id)
#
