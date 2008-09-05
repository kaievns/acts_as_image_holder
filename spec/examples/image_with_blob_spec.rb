require File.dirname(__FILE__)+"/../spec_helper"

describe ImageWithBlob do 
  before :all do
    @image = ImageWithBlob.new
  end
  
  it "should have the 'image=' method" do 
    @image.public_methods.should include("image=")
  end
  
  it "should be invalid" do 
    @image.should_not be_valid
    @image.errors.on(:image).should == "is required"
  end
  
  describe "not an image file assignment" do 
    before :all do 
      @image.image = File.open(__FILE__, 'rb')
    end
    
    it "should be invalid" do 
      @image.should_not be_valid
      @image.errors.on(:image).should == "is not an image"
    end
  end
  
  describe "wrong type of image assignment" do 
    before :all do 
      @image.image = File.open("#{$fixtures_dir}/test.gif", 'rb')
    end
    
    it "should be invalid" do 
      @image.should_not be_valid
      @image.errors.on(:image).should == "has wrong type"
    end
  end
  
  describe "correct image assignment" do 
    before :all do 
      @image.image = File.open("#{$fixtures_dir}/test.jpg", 'rb')
    end
    
    it "should be valid" do 
      @image.should be_valid
    end
    
    it "should assign the blob" do 
      @image.image.should_not be_nil
    end
    
    it "should assign the image type" do
      @image.image_type.should == "png"
    end
    
    it "should generate the thumbnail" do 
      @image.image_thumb.should_not be_nil
    end
  end
end
