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
      resize(file, field.size, field.type, field.quality)
    end
    
    #
    # creates a thumbnail of the image-file
    #
    def create_thumb(file, field)
      resize(file, field.size, field.type, field.quality)
    end
    
    # gets the image type
    def get_type(file)
      image_from(file).format.downcase.to_sym
    end
    
    # resizes the given file
    def resize(file, size, format=nil, quality=nil)
      size = size.split('x').collect{ |v| v.to_i} if size.is_a? String
      
      image = image_from(file)
      
      image.resize_to_fit! *size if size
      image.format = format.to_s if format
      
      image.to_blob { self.quality = quality if quality }
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
