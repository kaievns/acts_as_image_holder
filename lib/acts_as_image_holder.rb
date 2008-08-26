#
# The main module of the plugin
#
# Copyright (C) by Nikolay V. Nemshilov aka St.
#
module ActsAsImageHolder
  #
  # The method for the users
  #
  def acts_as_image_holder(options={ })
    options = Options.new(options)
    
    #
    # define validators
    #
    # required fields direct validation
    options.fields.each do |field|
      validates_presence_of field.image_field if field.required
    end
    
    # the other fields common validation
    validates_each options.fields.collect(&:image_field) do |record, attr, value|
      if @__acts_as_image_holder_problems
        record.errors.add attr, "is not an image" if @__acts_as_image_holder_problems[attr] == :not_an_image
        record.errors.add attr, "has wrong type"  if @__acts_as_image_holder_problems[attr] == :wrong_type
      end
    end
    
    #
    # define the image files setting handling
    #
    options.fields.each do |field|
      define_method "#{field.image_field}=" do |file|
        @__acts_as_image_holder_problems ||= { }
        @__acts_as_image_holder_filedata ||= { }
        
        begin
          # reading and converting the file
          filedata = ImageProc.prepare_data(file, field)
          thmbdata = ImageProc.create_thmb(file, field) if field.thmb_field
          
          # check if the file has a right type
          if !field.allowed_types or field.allowed_types.include? ImageProc.get_type(file)
            if options.output_directory
              # save the data for the future file-writting
              @__acts_as_image_holder_filedata[field.image_field] = filedata
              @__acts_as_image_holder_filedata[field.thmb_field]  = thmbdata if field.thmb_field
              
              # presetting the filenames for the future files
              self[field.image_field] = FileProc.guess_file_name(options, file)
              self[field.thmb_field]  = FileProc.guess_thmb_file_name(options, file) if field.thmb_field
              
            else
              # blobs direct assignment
              self[field.image_field] = filedata
              self[field.thmb_field]  = thmbdata if field.thmb_field
            end
            
            self[field.image_type_field] = "#{ImageProc.get_type(file)}" if field.image_type_field
            
          else
            @__acts_as_image_holder_problems[field.image_field] = :wrong_type
          end
          
        rescue Magick::ImageMagickError
          @__acts_as_image_holder_problems[field.image_field] = :not_an_image
        end
      end
    end
    
    #
    # defining file-based version additional features
    #
    if options.output_directory
      #
      # file url locations getters
      #
      options.fields.each do |field|
        define_method "#{field.image_field}_url" do 
          __file_url_for self[field.image_field] if self[field.image_field]
        end
        
        if field.thmb_field
          define_method "#{field.thmb_field}_url" do 
            __file_url_for self[field.thmb_field] if self[field.thmb_field]
          end
        end
      end
      
      # common file-urls compiler
      define_method "__file_url_for" do |relative_filename|
        full_filename = options.output_directory + relative_filename
        public_dir = "#{RAILS_ROOT}/public"
        
        full_filename[public_dir.size, full_filename.size]
      end
      
      
      #
      # define files handling callbacks
      #
      after_save :acts_as_image_holder_write_files
      after_destroy :acts_as_image_holder_remove_files
      
      # writting down the files
      define_method :acts_as_image_holder_write_files do 
        if @__acts_as_image_holder_filedata
          @__acts_as_image_holder_filedata.each do |field_name, filedata|
            FileProc.write_file(options, self[field_name], filedata)
          end
        end
      end
      
      # removing related files after the record is deleted
      define_method :acts_as_image_holder_remove_files do 
        options.fields.each do |field|
          FileProc.remove_file(options, self[field.image_field])
          FileProc.remove_file(options, self[field.thmb_field]) if field.thmb_field
        end
      end
    end
    
    #
    # Some additional useful images handling methods
    #
    # Resize a file and a blob-string
    #
    # @param file - File object or a string file-path
    # @param size - [width, height] array or a "widthxheight" string
    # @param format - "gif", "jpeg", "png", or nil to keep the same
    # @param quality - jpeg - quality 0 - 100, nil to keep the same
    #
    module_eval <<-"end_eval"
      def resize_file(file, size, format=nil, quality=nil)
        file = File.open(file) if file.is_a? String
        ImageProc.resize(file, size, format, quality)
      end
      
      def resize_blob(blob, size, format=nil, quality=nil)
        ImageProc.resize(blob, size, format, quality)
      end
    end_eval
  end 
end
