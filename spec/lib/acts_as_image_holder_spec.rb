require File.dirname(__FILE__)+"/../spec_helper"

class BlobbedImage < ActiveRecord::Base
  acts_as_image_holder :required => true,
                       :image_type_field => 'image_type',
                       :resize_to => '200x200',
                       :convert_to => :png,
                       :allowed_types => [:jpeg, :png],
                       :thmb_field => 'image_thmb'
end

describe ActsAsImageHolder do 
  describe "blobbed image" do 
    before :each do
      @image = BlobbedImage.new
    end
    
    it "should have the 'image=' method" do 
      @image.public_methods.include?("image=").should be_true
    end
    
    it "should be invalid" do 
      @image.should_not be_valid
      @image.errors.on(:image).should == "is required"
    end
    
    describe "not an image file assignment" do 
      before :each do 
        @image.image = File.open(__FILE__, 'rb')
      end
      
      it "should be invalid" do 
        @image.should_not be_valid
        @image.errors.on(:image).should == "is not an image"
      end
    end
    
    describe "wrong type of image assignment" do 
      before :each do 
        @image.image = File.open(File.dirname(__FILE__)+"/../images/test.gif", 'rb')
      end
      
      it "should be invalid" do 
        @image.should_not be_valid
        @image.errors.on(:image).should == "has wrong type"
      end
    end
    
    describe "correct image assignment" do 
      before :each do 
        @image.image = File.open(File.dirname(__FILE__)+"/../images/test.jpg", 'rb')
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
        @image.image_thmb.should_not be_nil
      end
    end
  end
end
