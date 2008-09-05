require File.dirname(__FILE__)+"/../spec_helper"

describe ImageWithSeveralFields do 
  before :all do 
    @image = ImageWithSeveralFields.new
  end
  
  it "should be valid" do 
    @image.should be_valid
  end
  
  it "should have assign methods for all the images" do 
    @image.public_methods.should include("image1=")
    @image.public_methods.should include("image2=")
    @image.public_methods.should include("image4=")
  end
  
  describe "first image assignment" do 
    before :all do 
      @image.image1 = File.open("#{$fixtures_dir}/test.jpg", 'rb')
    end
    
    it "should assign the image" do 
      @image.image1.should_not be_nil
    end
    
    it "should create each thumb" do 
      @image.image1_thumb1.should_not be_nil
      @image.image1_thumb2.should_not be_nil
      @image.image1_thumb3.should_not be_nil
    end
    
    describe "the image" do 
      before :all do 
        @image = Magick::Image.from_blob(@image.image1).first
      end
      
      it "should be in type of jpeg" do 
        @image.format.should == "JPEG"
      end
      
      it "should have correct size" do 
        @image.columns.should == 400
        @image.rows.should == 300
      end
    end
    
    describe "first thumb" do 
      before :all do 
        @image = Magick::Image.from_blob(@image.image1_thumb1).first
      end
        
      it "should be in type of jpeg" do 
        @image.format.should == "JPEG"
      end
      
      it "should fit the size of 200x200" do 
        @image.columns.should == 200
        @image.rows.should == 150
      end
      
      it "should have the quality 90%" do 
        @image.quality.should == 90
      end
    end
    
    describe "second thumb" do 
      before :all do 
        @image = Magick::Image.from_blob(@image.image1_thumb2).first
      end
      
      it "should be in type of jpeg" do 
        @image.format.should == "JPEG"
      end
      
      it "should fit the size of 100x100" do 
        @image.columns.should == 100
        @image.rows.should == 75
      end
      
      it "should have the quality 80%" do 
        @image.quality.should == 80
      end
    end
    
    describe "third thumb" do 
      before :all do 
        @image = Magick::Image.from_blob(@image.image1_thumb3).first
      end
      
      it "should bin type of png" do 
        @image.format.should == "PNG"
      end
      
      it "should fit the size of 80x80" do 
        @image.columns.should == 80
        @image.rows.should == 60
      end
    end
  end
  
  describe "second image assignment" do 
    before :all do 
      @image.image2 = File.open("#{$fixtures_dir}/test.jpg", 'rb')
    end
    
    it "should assign the image" do 
      @image.image2.should_not be_nil
    end
    
    it "should assign the original image" do 
      @image.image2_orig.should_not be_nil
    end
    
    it "should assign the thumb" do 
      @image.image2_thumb.should_not be_nil
    end
    
    describe "the image" do 
      before :all do 
        @image = Magick::Image.from_blob(@image.image2).first
      end
      
      it "should have right type" do 
        @image.format.should == "JPEG"
      end
      
      it "should have correct size" do 
        @image.columns.should == 200
        @image.rows.should == 150
      end
    end
    
    describe "the original image" do 
      before :all do 
        @image = Magick::Image.from_blob(@image.image2_orig).first
      end
      
      it "should have the original jpeg type" do 
        @image.format.should == "JPEG"
      end
      
      it "should have the original size" do 
        @image.columns.should == 400
        @image.rows.should == 300
      end
    end
    
    describe "the thumb image" do 
      before :all do 
        @image = Magick::Image.from_blob(@image.image2_thumb).first
      end
      
      it "should have the right type" do 
        @image.format.should == "GIF"
      end
      
      it "should have the right size" do 
        @image.columns.should == 40
        @image.rows.should == 30
      end
    end
  end
end
