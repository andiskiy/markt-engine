# == Schema Information
#
#  Table name: item_photos
#  id          :integer   not null, primary key
#  item_id     :integer   not null
#  photo       :string    not null
#

class ItemPhoto < ApplicationRecord
  mount_uploader :photo, PhotoUploader

  # Associations
  belongs_to :item

  # Validations
  validates :photo, :item_id, presence: true
end
