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
    
    if options[:image_fields]
      options[:image_fields].each do |image_options|
        @fields << Field.new(image_options) if image_options[:image_field]
      end
    else
      options[:image_field] ||= DEFAULT_IMAGE_FIELD
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
    OPTIONS = %w{image_field image_type_field resize_to convert_to required allowed_types quality
                 maximum_bytes jpeg_quality thmb_field thmb_size thmb_quality}.collect(&:to_sym)
    
    def initialize(options)
      @options = {}
      
      OPTIONS.each do |name|
        @options[name] = options[name] if defined? options[name]
      end
      
      @options[:resize_to] = parse_size(@options[:resize_to])
      @options[:thmb_size] = parse_size(@options[:thmb_size])
      
      @options[:thmb_type] = parse_type(@options[:thmb_type])
      @options[:thmb_type] ||= :jpeg
      
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
