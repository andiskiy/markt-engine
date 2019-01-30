# == Schema Information
#
#  Table name: categories
#  id          :integer   not null, primary key
#  name        :string
#  description :text
#

class Category < ApplicationRecord
  # Associations
  has_many :items

  # Validations
  validates :name, presence: true

end
