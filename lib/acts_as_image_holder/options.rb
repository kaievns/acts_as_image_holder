#
# User options parser/keeper
#
# Copyright (C) by Nikolay V. Nemshilov aka St.
#
class ActsAsImageHolder::Options
  DEFAULT_IMAGE_FIELD = 'image'
  
  attr_reader :fields, :output_directory, :subdirectories
  
  def initialize(options)
    find_fields_in options
    find_directory options
  end
  
protected
  def find_fields_in(options)
    @fields = []
    
    if options[:image_fields] or options[:images]
      (options[:image_fields] || options[:images]).each do |image_options|
        @fields << Field.new(image_options) if image_options[:image_field] or options[:images]
      end
    else
      @fields << Field.new(options)
    end
  end
  
  def find_directory(options)
    if options[:output_directory]
      @output_directory = options[:output_directory]
      @output_directory = "#{RAILS_ROOT}/public/images/#{@output_directory}" if @output_directory[0,1] != '/'
      @output_directory = @output_directory[0, @output_directory.size-1] if @output_directory[@output_directory.size-1,1] == '/'
      
      @subdirectories = options[:subdirectories] if options[:subdirectories]
    end
  end
  
  #
  # describes an image field options
  #
  class Field
    OPTIONS = %w{image_field image_type_field resize_to convert_to required allowed_types 
                 maximum_bytes jpeg_quality thumb_field thumb_size thumb_quality thumb_type
                 }.collect(&:to_sym)
    
    def initialize(options)
      options[:image_field] = options[:field] if options[:field] and !options[:image_field]
      options[:image_field] ||= DEFAULT_IMAGE_FIELD
      
      options[:image_type_field] = options[:type_field] if options[:type_field] and !options[:image_type_field]
      
      @options = {}
      
      OPTIONS.each do |name|
        @options[name] = options[name] if defined? options[name]
      end
      
      @options[:resize_to] = parse_size(@options[:resize_to])
      @options[:thumb_size] = parse_size(@options[:thumb_size])
      
      @options[:thumb_type] = parse_type(@options[:thumb_type])
      @options[:thumb_type] ||= :jpeg
      
      @options[:convert_to] = parse_type(@options[:convert_to])
      @options[:allowed_types] = @options[:allowed_types].collect{ |t| parse_type(t)} if @options[:allowed_types]
    end
    
    def method_missing(name, *args, &block)
      if defined? @options[name]
        @options[name]
      else
        super(name, *args, &blcok)
      end
    end
    
  protected
    # parses the size into the internal format
    def parse_size(option)
      if option and option.is_a?(String) and option.split('x').size == 2
        option = option.split('x').collect{ |v| v.to_i }
      end
      
      option
    end
    
    def parse_type(option)
      if option
        t = option.to_s.downcase.to_sym
        t == :jpg ? :jpeg : t
      end
    end
  end
end
