#
# this model has several images and thumbnails in it
#
class ImageWithSeveralFields < ActiveRecord::Base
  acts_as_image_holder :images => [
                         { :field => :image1,
                           :thumbs => [
                             { :field => :image1_thumb1, :size => "200x200", :type => :jpeg, :quality => 90 },
                             { :field => :image1_thumb2, :size => "100x100", :type => :jpeg, :quality => 80 },
                             { :field => :image1_thumb3, :size => "80x80",   :type => :png }
                           ]},
                                   
                         { :field       => :image2,
                           :resize_to   => "200x200",
                           :original    => :image2_orig,
                           :thumb_field => :image2_thumb,
                           :thumb_size  => "40x40",
                           :thumb_type  => :gif },
                                   
                         { :field  => :image4,
                           :watermark => { 
                             :text => "It's mine!",
                             :font => { 
                               :size => '20px',
                               :position => [:center, :center]
                             }
                           },
                           :thumb_field => :image4_thumb,
                           :thumb_watermark => { 
                             :file => File.dirname(__FILE__)+"/../images/test.gif",
                             :position => [-10, -10]
                           }
                         }
                       ]
end
