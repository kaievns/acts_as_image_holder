require 'RMagick'
#
# This class handles the images proccessing
#
# Copyright (C) by Nikolay V. Nemshilov aka St.
#
class ActsAsImageHolder::ImageProc
  class << self
    #
    # prepares the data of the field, perfomes resizing and type changes
    #
    def prepare_data(file, field)
      resize(file, field.resize_to, field.convert_to, field.jpeg_quality).to_blob
    end
    
    #
    # creates a thumbnail of the image-file
    #
    def create_thumb(file, field)
      resize(file, field.thumb_size, field.thumb_type, field.thumb_quality).to_blob
    end
    
    # gets the image type
    def get_type(file)
      image_from(file).format.downcase.to_sym
    end
    
    # resizes the given file
    def resize(file, size, format=nil, quality=nil)
      size = size.split('x').collect{ |v| v.to_i} if size.is_a? String
      
      image = image_from(file)
      
      image.quality = quality               if quality
      image.resize_to_fit! size[0], size[1] if size
      image.format = format.to_s            if format
      
      image
    end
    
  private
    # converts the source into an image object
    def image_from(src)
      if src.is_a? String
        Magick::Image.from_blob(src).first
        
      else # <- assumed a file pointer
        src.rewind
        Magick::Image.read(src).first
      end
    end
  end
end
