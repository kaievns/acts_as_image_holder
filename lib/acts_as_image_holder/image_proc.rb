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
      resize(file, field.resize_to, field.convert_to, field.quality).to_blob
    end
    
    #
    # creates a thmbnail of the image-file
    #
    def create_thmb(file, field)
      resize(file, field.thmb_size, field.thmb_type, field.thmb_quality).to_blob
    end
    
    # gets the image type
    def get_type(file)
      if file.is_a? String
        image = Magick::Image.from_blob(file).first
      else
        file.rewind
        image = Magick::Image.read(file).first
      end
      
      image.format.downcase.to_sym
    end
    
    # resizes the given file
    def resize(file, size, format=nil, quality=nil)
      size = size.split('x').collect{ |v| v.to_i} if size.is_a? String
      
      if file.is_a? String
        image = Magick::Image.from_blob(file).first
      else
        file.rewind
        image = Magick::Image.read(file).first
      end
      
      image.quality = quality if quality
      
      image.resize_to_fit! size[0], size[1] if size
      image.format = format.to_s if format
      
      image
    end
  end
end
