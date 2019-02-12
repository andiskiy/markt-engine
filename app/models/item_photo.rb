# == Schema Information
#
#  Table name: item_photos
#  id          :integer   not null, primary key
#  item_id     :integer
#  photo       :string
#  created_at  :datetime  not null
#  updated_at  :datetime  not null
#

class ItemPhoto < ApplicationRecord
  mount_uploader :photo, PhotoUploader

  # Associations
  belongs_to :item

  # Validations
  validates :photo, presence: true
end
