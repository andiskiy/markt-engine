class ItemPhoto < ApplicationRecord
  mount_uploader :photo, PhotoUploader

  # Associations
  belongs_to :item
end
