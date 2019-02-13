# == Schema Information
#
#  Table name: items
#  id          :integer   not null, primary key
#  name        :string
#  description :text
#  price       :float
#  category_id :integer
#  deleted_at  :datetime
#  created_at  :datetime  not null
#  updated_at  :datetime  not null
#

class Item < ApplicationRecord
  include Versionable
  PER_PAGE = 50

  acts_as_paranoid

  has_paper_trail on:   :update,
                  only: %i[name price]

  versionable :name, :price

  # Associations
  belongs_to :category
  belongs_to :prev_category, class_name: 'Category', optional: true
  has_many :item_photos
  has_many :users, through: :orders
  has_many :orders

  accepts_nested_attributes_for :item_photos, allow_destroy: true, reject_if: :all_blank

  # Validations
  validates :name, :price, presence: true

  class << self
    def search(value, category_id)
      items = where('name ILIKE :value', value: "%#{value}%")
      category_id.present? ? items.where(category_id: category_id) : items
    end
  end

  def ensure_five_photos
    needed_photos_count.times { association(:item_photos).add_to_target(ItemPhoto.new) }
  end

  private

  def needed_photos_count
    needed = 5 - item_photos.length
    needed.positive? ? needed : 0
  end
end
