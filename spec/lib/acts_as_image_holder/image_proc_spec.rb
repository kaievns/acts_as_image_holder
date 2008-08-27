require File.dirname(__FILE__)+"/../../spec_helper"

describe ActsAsImageHolder::ImageProc do 
  before :each do 
    @file = File.open(File.dirname(__FILE__)+"/../../images/test.jpg", "rb")
    @field = ActsAsImageHolder::Options.new(:resize_to => '200x200', :thumb_size => '40x40',
                                            :convert_to => :png).fields.first
  end
  
  describe "prepare_date" do 
    before :each do 
      @data = ActsAsImageHolder::ImageProc.prepare_data(@file, @field)
      @image = Magick::Image.from_blob(@data).first
    end
    
    it "should not be a nil" do 
      @data.should_not be_nil
    end
    
    it "should be a png-image" do 
      @image.format.should == "PNG"
    end
    
    it "should have correct size" do 
      @image.columns.should == 200
      @image.rows.should == 150 # <- keep resolution
    end
  end
  
  describe "create_thumb" do 
    before :each do 
      @data = ActsAsImageHolder::ImageProc.create_thumb(@file, @field)
      @image = Magick::Image.from_blob(@data).first
    end
    
    it "should not be a nil" do 
      @data.should_not be_nil
      @image.format.should == "JPEG"
    end
    
    it "should have correct size" do 
      @image.columns.should == 40
      @image.rows.should == 30
    end
  end
  
  describe "get_type" do 
    it "should recognize the jpeg type" do 
      ActsAsImageHolder::ImageProc.get_type(@file).should == :jpeg
    end
  end
end
