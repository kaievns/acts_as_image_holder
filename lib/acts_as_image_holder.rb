module ActsAsImageHolder
  #
  # 
  #
  def acts_as_image_holder(options={ })
    options = acts_as_image_holder_clean_options(options)
  end
  
private
  # cleans up the user-specified options
  def acts_as_image_holder_clean_options(options)
    options = {
      :image_fields => nil,
      
      :output_directory => nil,
      :subdirectories => nil
    }.merge(options)
    
    # each image field might be defined with the options
    image_options = [
      :image_field,
      :image_type_field,

      :resize_to,
      :convert_to,
      :allowed_types,
      :maximum_bytes,

      :thmb_field,
      :thmb_size
    ]
    
    
    if options[:image_fields]
      # checking the image-fields list
      
    elsif options[:image_field]
      # trying to push default image-definition
      image_def = {}
      image_options.each do |name|
        image_def[name] = options[name]
      end
      options[:image_fields] = [image_def]
    end
    
    options
  end
end
