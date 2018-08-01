class Painting < ApplicationRecord

	# belongs_to :painting
	mount_uploader :image, ImageUploader

	# has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

	# has_one_attached :image
end
