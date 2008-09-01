require 'RMagick'
#
# This class does the process of putting watermarks
# on images
#
# Copyright (C) by Nikolay V. Nemshilov aka St.
#
class ActsAsImageHolder::ImageProc::Watermarker
  class << self
    DEFAULT_FONT_SIZE = 20
    DEFAULT_FONT_FAMILY = "Helvetica"
    
    # frontside method
    def process(image, options)
      image = image.clone
      
      image.composite!(create_watermark_image(image, options),
                       gravity_from(options),
                       composite_op_form(options))
      
      image
    end
    
    # creates the image object by the given options
    def create_watermark_image(original, options)
      image = Magick::Image.new(original.columns, original.rows) { 
        self.background_color = 'transparent'
      }
      
      if options[:text]
        put_text_watermark_on image, options
      elsif options[:file]
        put_file_watermark_on image, options
      end
      
      # applying the shade effect if asked
      image = image.shade *options[:shade] if options[:shade]
      
      # putting on a shadow
      if options[:shadow]
        # options normalization
        options[:shadow] = [4,4,4,1] if options[:shadow] == true
        options[:shadow][1] = 4 unless options[:shadow][1]
        
        # shadow generation
        shadow = image.shadow *options[:shadow]
        shadow = shadow.colorize(1,1,1, options[:shadow_color]) if options[:shadow_color]
        
        # recomposing the image with the shadow
        image = Magick::Image.new(original.columns, original.rows) { 
          self.background_color = 'transparent'
        }.composite!(shadow, Magick::CenterGravity, options[:shadow][0], options[:shadow][1], Magick::OverCompositeOp
        ).composite!(image,  Magick::CenterGravity, Magick::OverCompositeOp)
        # image = shadow.composite! image, Magick::CenterGravity, -options[:shadow][0], -options[:shadow][1],  Magick::OverCompositeOp
      end
      
      image
    end
   
    # creates an watermark image from the text-options
    def put_text_watermark_on(image, options)
      font = options[:font] || { }
      
      # initalizing the text drawer
      gc = Magick::Draw.new
      gc.gravity         = gravity_from(options)
      gc.pointsize       = font[:size] || DEFAULT_FONT_SIZE
      gc.font_family     = font[:family] || DEFAULT_FONT_FAMILY
      gc.font_weight     = font_weight_from font[:weight]
      gc.font_style      = font_style_from font[:style]
      gc.font_stretch    = font[:stretch]         if font[:stretch]
      gc.fill            = options[:color]        if options[:color]
      gc.stroke          = options[:stroke]       if options[:stroke]
      gc.stroke_width    = options[:stroke_width] if options[:stroke_width]
      gc.undercolor      = options[:undercolor]   if options[:undercolor]
    
      gc.text_align(text_align_from(options[:text_align]))
      
      # calculating the annotaion position
      x = y = options[:offset] || 0
      gc.annotate(image, 0, 0, x, y, options[:text]) { 
        self.rotation = options[:rotate] if options[:rotate]
      }
    end
    
    # puts another image file on the image as a watermark
    def put_file_watermark_on(image, options)
      gc = Magick::Image.read(options[:file]).first
      gc.rotate! options[:rotate] if options[:rotate]
      
      # composing the image with the received image
      x = y = options[:offset] || 0
      image.composite! gc, gravity_from(options), x, y, Magick::OverCompositeOp
    end
    
    # returns the gravity pointer out of the options
    def gravity_from(options)
      position = options[:position] || :forget
      
      position = position.to_s.downcase.to_sym unless position.is_a?(Array)
      position = position.collect{ |s| s.to_s.downcase }.sort.join("_").to_sym if position.is_a?(Array)
      
      case position
      when :left_top, :northwest           then Magick::NorthWestGravity
      when :top, :center_top, :north       then Magick::NorthGravity
      when :right_top, :northeast          then Magick::NorthEastGravity
      when :left, :center_left, :west      then Magick::WestGravity
      when :center, :center_center         then Magick::CenterGravity
      when :right, :center_right, :east    then Magick::EastGravity
      when :bottom_left, :southwest        then Magick::SouthWestGravity
      when :bottom, :bottom_center, :south then Magick::SouthGravity
      when :bottom_right, :southeast       then Magick::SouthEastGravity           
      else                                      Magick::ForgetGravity
      end
    end
    
    def font_weight_from(option)
      case option.to_s.downcase
      when 'bold'    then Magick::BoldWeight
      when 'bolder'  then Magick::BolderWeight
      when 'normal'  then Magick::NormalWeight
      when 'lighter' then Magick::LighterWeight
      else                Magick::AnyWeight
      end
    end
    
    def font_style_from(option)
      case option.to_s.downcase
      when 'normal'  then Magick::NormalStyle
      when 'italic'  then Magick::ItalicStyle
      when 'oblique' then Magick::ObliqueStyle
      else                Magick::AnyStyle
      end
    end
    
    def text_align_from(option)
      case option.to_s.downcase
      when 'left'   then Magick::LeftAlign
      when 'center' then Magick::CenterAlign
      when 'right'  then Magick::RightAlign
      else               Magick::CenterAlign
      end
    end
    
    def composite_op_form(options)
      case options[:composite_op]
      when 'over'       then Magick::OverCompositeOp
      when 'soft_light' then Magick::SoftLightCompositeOp
      when 'hard_light' then Magick::HardLightCompositeOp
      else
        if options[:shade]
          Magick::HardLightCompositeOp
        else
          Magick::OverCompositeOp
        end
      end
    end
  end
end
