#
# User options parser/keeper
#
# Copyright (C) by Nikolay V. Nemshilov aka St.
#
class ActsAsImageHolder::Options
  DEFAULT_IMAGE_FIELD_NAME = "image"
  DEFAULT_THUMB_SIZE       = "200x150"
  
  attr_reader :images, :directory, :subdirs
  
  def initialize(options)
    find_images_in options
    find_directory options
  end
  
protected
  def find_images_in(options)
    @images = []
    
    if options[:images]
      options[:images].each do |image|
        @images << Image.new(image) if image[:field] or image[:image_field]
      end
    else
      @images << Image.new(options)
    end
  end
  
  def find_directory(options)
    if @directory = options[:directory] || options[:output_directory]
      @directory = "#{RAILS_ROOT}/public/images/#{@directory}" if @directory[0,1] != '/'
      @directory = @directory[0, @directory.size-1] if @directory[@directory.size-1,1] == '/'
      
      @subdirs = options[:subdirs] || options[:subdirectories]
    end
  end
  
  #
  # Mixing for the options parsing
  #
  module OptionsParser
    # parses the size into the internal format
    def parse_size(option)
      if option and option.is_a?(String) and option.split('x').size == 2
        option = option.split('x').collect{ |v| v.to_i }
      end
      
      option
    end
    
    # creates correct symbolic type out of the type option
    def parse_type(option)
      if option
        t = option.to_s.downcase.to_sym
        t == :jpg ? :jpeg : t
      end
    end
    
    #
    # Parses and represents the watermarking options
    #
    class Watermark
      PUBLIC_ATTRS = [
        :file, :text, :font, :position, :shadow, :shadow_color, :shade, :composite_op,
        :stroke, :stroke_width, :color, :rotate, :offset, :undercolor, :text_align
      ]
      attr_reader *PUBLIC_ATTRS
      
      def initialize(options)
        PUBLIC_ATTRS.each do |name|
          instance_variable_set "@#{name}", options[name]
        end
        
        @position ||= [:bottom, :right]
        @offset   ||= 10
      end
      
      def [](key)
        send(key)
      end
    end
  end
  
  #
  # describes an image field options
  #
  class Image
    include OptionsParser
    
    attr_reader :field, :type_field, :size, :type, :quality, :original,
                :required, :allowed_types, :maximum_bytes, :watermark, :thumbs
    
    def initialize(options)
      @field      = options[:field] || options[:image_field] || DEFAULT_IMAGE_FIELD_NAME
      @type_field = options[:type_field] || options[:image_type_field]
      @size       = parse_size(options[:resize_to] || options[:type])
      @type       = parse_type(options[:convert_to] || options[:size])
      @quality    = options[:quality] || options[:jpeg_quality]
      @original   = options[:original] || options[:original_field]
      @required   = options[:required]
      @watermark  = Watermark.new(options[:watermark]||options[:image_watermark]) if options[:watermark] || options[:image_watermark]
      @allowed_types = options[:allowed_types].to_a.collect{ |t| parse_type(t) } if options[:allowed_types]
      @maximum_bytes = options[:maximum_bytes]
      
      find_thumbs_in options.reject{ |k,v| [:field, :type, :size, :quality].include? k }
    end
    
    # checks if the image allowed the given type
    def allowed_type?(t)
      !allowed_types or allowed_types.include?(t)
    end
    
    def find_thumbs_in(options)
      @thumbs = []
      
      if options[:thumbs].is_a? Array
        options[:thumbs].each do |thumb_options|
          @thumbs << Thumb.new(thumb_options)
        end
      elsif options[:thumb_field]
        @thumbs << Thumb.new(options)
      end
    end
    
    # parses out and represents the thumb options
    class Thumb
      include OptionsParser
      
      attr_reader :field, :type, :size, :quality, :watermark
      
      def initialize(options)
        @field = options[:field] || options[:thumb_field]
        @type  = parse_type( options[:type] || options[:thumb_type] || :jpeg )
        @size  = parse_size( options[:size] || options[:thumb_size] || DEFAULT_THUMB_SIZE )
        @quality = options[:quality] || options[:thmb_quality]
        @watermark = Watermark.new(options[:watermark] || options[:thumb_watermark]) if options[:watermark] or options[:thumb_watermark]
      end
    end
  end
end
