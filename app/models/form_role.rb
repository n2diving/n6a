class FormRole < ApplicationRecord
  has_many :review_items_by_roles
  validates_uniqueness_of :role

  # default_scope { where.not(role: 'team') }
  scope :no_team, -> { where.not(role: 'Team') }
  scope :limited, -> { where(abbreviation: ["AM", "AC", "AE", "SAE", "EMP"]) }
  scope :limited_without_sae, -> { where(abbreviation: ["AM", "AC", "AE", "EMP"]) }

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
