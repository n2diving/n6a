class FormRole < ApplicationRecord
  has_many :review_items_by_roles
  validates_uniqueness_of :role
end

# == Schema Information
#
# Table name: form_roles
#
#  id           :integer          not null, primary key
#  role         :string
#  abbreviation :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
