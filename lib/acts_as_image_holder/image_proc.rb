class ActsAsImageHolder::ImageProc
  class << self
    #
    # prepares the data of the field, perfomes resizing and type changes
    #
    def prepare_data(field, file)
      
    end
    
    #
    # creates a thmbnail of the image-file
    #
    def create_thmb(field, file)
      
    end
    
    # gets the image type
    def get_type(file)
      file.content_type.split('/').last.downcase.to_sym
    end
  end
end
