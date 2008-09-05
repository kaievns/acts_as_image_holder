#
# This model keeps its images in files
#
class ImageWithFile < ActiveRecord::Base
  acts_as_image_holder :image_field => 'image_file',
                       :image_type_field => 'image_type',
                       :resize_to => '200x200',
                       :convert_to => :png,
                       :allowed_types => [:jpeg, :png],
                       :thumb_field => 'image_thumb_file',
                       :thumb_type => :gif,
                       :thumb_size => '40x40',
                       :thumb_quality => 90,
                       :output_directory => '/tmp/images_test'
end
