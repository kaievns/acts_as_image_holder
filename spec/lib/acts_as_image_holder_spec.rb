require File.dirname(__FILE__)+"/../spec_helper"

class BlobbedImage < ActiveRecord::Base
  acts_as_image_holder :required => true,
                       :image_type_field => 'image_type',
                       :resize_to => '200x200',
                       :convert_to => :png,
                       :allowed_types => [:jpeg, :png],
                       :thumb_field => 'image_thumb'
end

class ImageWithFile < ActiveRecord::Base
  acts_as_image_holder :image_field => 'image_file',
                       :image_type_field => 'image_type',
                       :resize_to => '200x200',
                       :convert_to => :png,
                       :allowed_types => [:jpeg, :png],
                       :thumb_field => 'image_thumb_file',
                       :thumb_type => :gif,
                       :thumb_size => '40x40',
                       :output_directory => '/tmp/images_test'
end

describe ActsAsImageHolder do 
  describe "blobbed image" do 
    before :each do
      @image = BlobbedImage.new
    end
    
    it "should have the 'image=' method" do 
      @image.public_methods.should include("image=")
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
        @image.image_thumb.should_not be_nil
      end
    end
  end
  
  describe "image with file" do 
    before :each do
      @image = ImageWithFile.new
      FileUtils.rm_rf ImageWithFile::FILES_DIRECTORY
    end
    
    it "should have the 'image_file=' method" do 
      @image.public_methods.should include('image_file=')
    end
    
    it "should be valid (because the image is not required)" do 
      @image.should be_valid
    end
    
    describe "not an image file assignment" do 
      before :each do 
        @image.image_file = File.open(__FILE__, 'rb')
        @image.valid?
      end
      
      it "should be invalid" do 
        @image.should_not be_valid
      end
      
      it "should have a proper error on the field" do 
        @image.errors.on(:image_file).should == "is not an image"
      end
      
      it "should not copy the file to the output directory" do 
        File.should_not be_exists(ImageWithFile::FILES_DIRECTORY)
      end
    end
    
    describe "wrong image type assignment" do 
      before :each do
        @image.image_file = File.open(File.dirname(__FILE__)+"/../images/test.gif", 'rb')
        @image.valid?
      end
      
      it "should not be valid" do 
        @image.should_not be_valid
      end
      
      it "should have a proper error message" do 
        @image.errors.on(:image_file).should == "has wrong type"
      end
      
      it "should not copy the file to the output directory" do 
        File.should_not be_exists(ImageWithFile::FILES_DIRECTORY)
      end
    end
    
    describe "correct image assignment" do 
      before :each do 
        @image.image_file = File.open(File.dirname(__FILE__)+"/../images/test.jpg", 'rb')
      end
      
      it "should be valid" do 
        @image.should be_valid
      end
      
      it "should have assigned the image file-name to the field" do 
        @image.image_file.should == 'test.png'
      end
      
      it "should have assigned the image type" do 
        @image.image_type.should == 'png'
      end
      
      it "should have assigned the thumb file-name" do 
        @image.image_thumb_file.should == 'test-thumb.gif'
      end
      
      it "should not write the files yet" do 
        File.should_not be_exists(ImageWithFile::FILES_DIRECTORY)
      end
      
      describe "record saving" do 
        before :each do 
          @image.save
        end
        
        it "should get saved" do 
          @image.should_not be_new_record
        end
        
        it "should create the image file" do 
          File.should be_exists("#{ImageWithFile::FILES_DIRECTORY}/test.png")
        end
        
        it "should create the thumb file" do 
          File.should be_exists("#{ImageWithFile::FILES_DIRECTORY}/test-thumb.gif")
        end
        
        describe "image-file" do 
          before :each do 
            @image = Magick::Image.read("#{ImageWithFile::FILES_DIRECTORY}/test.png").first
          end
          
          it "should be a png image" do 
            @image.format.should == 'PNG'
          end
          
          it "should have correct sizes" do 
            @image.columns.should == 200
            @image.rows.should == 150
          end
        end
        
        describe "thumb-file" do 
          before :each do 
            @image = Magick::Image.read("#{ImageWithFile::FILES_DIRECTORY}/test-thumb.gif").first
          end
          
          it "should be a gif image" do 
            @image.format.should == 'GIF'
          end
          
          it "should have correct sizes" do 
            @image.columns.should == 40
            @image.rows.should == 30
          end
        end
        
        describe "image removing" do 
          before :each do 
            @image.destroy
          end
          
          it "should remove the image file" do 
            File.should_not be_exists("#{ImageWithFile::FILES_DIRECTORY}/test.png")
          end
          
          it "should remove the thumb file" do 
            File.should_not be_exists("#{ImageWithFile::FILES_DIRECTORY}/test-thumb.gif")
          end
        end
      end
    end
  end
end
