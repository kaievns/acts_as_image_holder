#
# This record keeps its images in blobs
#
class ImageWithBlob < ActiveRecord::Base
  acts_as_image_holder :required => true,
                       :image_type_field => 'image_type',
                       :resize_to => '200x200',
                       :convert_to => :png,
                       :allowed_types => [:jpeg, :png],
                       :thumb_field => 'image_thumb'
end
