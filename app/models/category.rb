# == Schema Information
#
#  Table name: categories
#  id          :integer   not null, primary key
#  name        :string
#  description :text
#  deleted_at  :datetime
#  created_at  :datetime  not null
#  updated_at  :datetime  not null
#

class Category < ApplicationRecord
  PER_PAGE = 10

  acts_as_paranoid

  # Associations
  has_many :items

  # Validations
  validates :name, presence: true

  # Scopes
  scope :search, ->(value) { where('name ILIKE :value', value: "%#{value}%") }
end
