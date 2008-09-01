require File.dirname(__FILE__)+"/../../../spec_helper.rb"

describe ActsAsImageHolder::ImageProc::Watermarker do 
  before :all do 
    @test_file_name = File.dirname(__FILE__) + "/../../../images/test.jpg"
  end
  
  describe "watermarking with a text" do 
    before :all do 
      @options = { 
        :text => "That's mine!",
        :font => {
          :size => 40,
          :family => "Verdana",
          :weight => "bold",
          :style => :italic
        },
        :stroke => 'black',
        :stroke_width => 1,
        :color => '#ABC',
       # :rotate => 90,
        :position => [:bottom, :right],
        :offset => 20,
       # :undercolor => '#FEE',
        :shadow => [4, 4, 2, 1],
        :shadow_color => "blue",
        :shade => nil # [false, 310, 30]
      }
      
      @image = Magick::Image.read(@test_file_name).first
      @out_image = ActsAsImageHolder::ImageProc::Watermarker.process(@image, @options)
    end
    
    it "save the image" do 
    #  FileUtils.mkdir_p "/tmp/images"
    #  File.open("/tmp/images/test.jpg", "wb") do |file|
    #    file.write @out_image.to_blob
    #  end
    end
    
    it "should have the same format" do 
      @out_image.format.should == @image.format
    end
    
    it "should have the same resolution" do 
      @out_image.columns.should == @image.columns
      @out_image.rows.should == @image.rows
    end
    
    it "should have another info" do 
      @out_image.to_blob.should_not == @image.to_blob
    end
  end
  
  describe "watermarking with an image" do 
    before :all do 
      @options = {
        :file => File.dirname(__FILE__) + "/../../../images/test.gif",
        :position => [:bottom, :right],
        :offset => 10,
        :rotate => 90,
        :shadow => [2, 2, 1, 0.5]
      }
      
      @image = Magick::Image.read(@test_file_name).first
      
      @out_image = ActsAsImageHolder::ImageProc::Watermarker.process(@image, @options)
    end
    
    it "save the image" do 
    #  FileUtils.mkdir_p "/tmp/images"
    #  File.open("/tmp/images/test.jpg", "wb") do |file|
    #    file.write @out_image.to_blob
    #  end
    end
    
    it "should have the same format" do 
      @out_image.format.should == @image.format
    end
    
    it "should have the same resolution" do 
      @out_image.columns.should == @image.columns
      @out_image.rows.should == @image.rows
    end
    
    it "should have another info" do 
      @out_image.to_blob.should_not == @image.to_blob
    end
  end
end
