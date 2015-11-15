class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope { order(created_at: :desc) }

  # When a record is saved,
  # the uploaded picture is stored automatically.
  mount_uploader :picture, PictureUploader

  validates :user_id,
    presence: true
  validates :content,
    presence: true,
    length: { maximum: 140 }

  validate :picture_size

  private

    # Validates the size of an uploaded picture.
    def picture_size
      if 5.megabytes < picture.size
        errors.add(:picture, 'should be less than 5MB')
      end
    end
end