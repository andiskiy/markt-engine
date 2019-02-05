# == Schema Information
#
#  Table name: categories
#  id          :integer   not null, primary key
#  name        :string
#  description :text
#

class Category < ApplicationRecord
  PER_PAGE = 10

  # Associations
  has_many :items

  # Validations
  validates :name, presence: true

end
