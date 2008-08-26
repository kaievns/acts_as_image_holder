require File.dirname(__FILE__)+"/../spec_helper"

class Image < ActiveRecord::Base
  acts_as_image_holder :required => true,
                       :image_type_field => 'image_type',
                       :thmb_field => 'image_thmb'
end

describe ActsAsImageHolder do 
  describe "blobbed image" do 
    before :each do 
     # @image = Image.new
    end
    
    it "should have the 'image=' method" do 
    #  @image.public_methods.include?("image=").should be_true
    end
    
    it "should be invalid" do 
    #  @image.image = 'bla'
      
      
    #  @image.should_not be_valid
    end
  end
end
