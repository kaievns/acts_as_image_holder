require File.dirname(__FILE__)+"/../../spec_helper.rb"

describe ActsAsImageHolder::Options do 
  describe "default image definition" do 
    before :each do 
      @o = ActsAsImageHolder::Options.new({ })
    end
    
    it "should have 1 field" do 
      @o.should have(1).image
    end
    
    describe "image" do 
      before :each do 
        @image = @o.images.first
      end
      
      it "should has the name of 'image'" do 
        @image.field.should == 'image'
      end
      
      it "should have not set the other fields" do 
        %w{type_field size type allowed_types maximum_bytes 
           quality original}.each do |name|
          
          @image.send(name).should be_nil
        end
      end
    end
  end
  
  describe "image options passing" do 
    before :each do 
      @o = ActsAsImageHolder::Options.new({ :image_field => 'my_field',
                                            :image_type_field => 'my_field_type',
                                            :original_field => 'my_field_original',
                                            
                                            :resize_to => '400x300',
                                            :convert_to => :jpg,
                                            :allowed_types => [:png, 'gif', 'JPEG'],
                                            :maximum_bytes => 2.kilobytes,
                                            :jpeg_quality => 90,
                                            
                                            :thumb_field => 'my_field_thumb',
                                            :thumb_size => '40x30'
                                          })
    end
    
    it "should have 1 image" do 
      @o.should have(1).image
    end
    
    describe "image" do 
      before :each do 
        @f = @o.images.first
      end
      
      it "should set the field" do 
        @f.field.should == 'my_field'
      end
      
      it "should set the type-field" do 
        @f.type_field.should == 'my_field_type'
      end
      
      it "should set the original field" do 
        @f.original.should == 'my_field_original'
      end
      
      it "should set the size" do 
        @f.size.should == [400, 300]
      end
      
      it "should apply the type" do 
        @f.type.should == :jpeg
      end
      
      it "should apply the types" do 
        @f.allowed_types.should == [:png, :gif, :jpeg]
      end
      
      it "should set the maximum-bytes" do 
        @f.maximum_bytes.should == 2048
      end
      
      it "should set the quality" do 
        @f.quality.should == 90
      end
      
      it "should have one thumb" do
        @f.should have(1).thumb
      end
      
      describe "thumb" do 
        before :each do 
          @thumb = @f.thumbs.first
        end
        
        it "should have the field" do 
          @thumb.field.should == 'my_field_thumb'
        end
      
        it "should have the size" do 
          @thumb.size.should == [40, 30]
        end
      end
    end
  end
  
  describe "several image-fields definition" do 
    before :each do 
      @o = ActsAsImageHolder::Options.new({ :images => [{ :image_field => 'field1' },
                                                        { :image_field => 'field2' }
                                                       ]
                                          })
    end
    
    it "should have two images" do 
      @o.should have(2).images
    end
    
    describe "first image" do 
      before :each do 
        @image = @o.images.first
      end
      
      it "should have the field" do 
        @image.field.should == 'field1'
      end
    end
    
    describe "second image" do 
      before :each do 
        @image = @o.images.last
      end
      
      it "should have the field" do 
        @image.field.should == 'field2'
      end
    end
  end
  
  describe "several image-fields definition by shortify notification" do 
    before :each do 
      @o = ActsAsImageHolder::Options.new({
        :images => [{ :field => 'field1', :convert_to => :jpg },
                    { :field => 'field2', :type_field => 'field2_type'}
                   ]
      })
    end
    
    it "should have two fields" do 
      @o.should have(2).images
    end
    
    describe "first image" do 
      before :each do 
        @image = @o.images.first
      end
      
      it "should have the field" do 
        @image.field.should == 'field1'
      end
      
      it "should have the type" do 
        @image.type.should == :jpeg
      end
    end
    
    describe "second image" do 
      before :each do 
        @image = @o.images.last
      end
      
      it "should have the field" do 
        @image.field.should == 'field2'
      end
      
      it "should have the type-field" do 
        @image.type_field == 'field2_type'
      end
    end
  end
  
  describe "directory options" do 
    describe "absolute path" do 
      before :each do 
        @o = ActsAsImageHolder::Options.new({:output_directory => '/asdf/asdf', :subdirectories => 'asdf'})
      end
      
      it "should set the directory option" do 
        @o.directory.should == '/asdf/asdf'
      end
      
      it "should set the subdirs option" do 
        @o.subdirs.should == 'asdf'
      end
    end
    
    describe "relative path" do 
      before :each do 
        @o = ActsAsImageHolder::Options.new(:output_directory => 'uploads')
      end
      
      it "should set the directory option" do 
        @o.directory.should == "#{RAILS_ROOT}/public/images/uploads"
      end
    end
    
    describe "short version" do 
      before :each do 
        @o = ActsAsImageHolder::Options.new(:directory => '/asdf', :subdirs => 'bla')
      end
      
      it "should set the directory" do 
        @o.directory.should == "/asdf"
      end
      
      it "should set the subdirs" do 
        @o.subdirs.should == "bla"
      end
    end
  end
end
