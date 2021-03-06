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

  # Attributes
  attr_accessor :category_id

  # Associations
  has_many :items, -> { order_by_name }, inverse_of: :category

  # Validations
  validates :name, presence: true

  # Scopes
  scope :search, ->(value) { where('name ILIKE :value', value: "%#{value}%") }
  scope :order_by_name, -> { order(name: :asc) }
end
