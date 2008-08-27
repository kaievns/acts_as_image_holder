require File.dirname(__FILE__)+"/../../spec_helper.rb"

describe ActsAsImageHolder::Options do 
  describe "default image definition" do 
    before :each do 
      @o = ActsAsImageHolder::Options.new({ })
    end
    
    it "should have 1 field" do 
      @o.should have(1).field
    end
    
    describe "field" do 
      before :each do 
        @f = @o.fields.first
      end
      
      it "should has the name of 'image'" do 
        @f.image_field.should == 'image'
      end
      
      it "should have not set the other fields" do 
        %w{image_type_field resize_to convert_to allowed_types maximum_bytes 
           jpeg_quality thumb_field thumb_size}.each do |name|
          
          @f.send(name).should be_nil
        end
      end
    end
  end
  
  describe "image options passing" do 
    before :each do 
      @o = ActsAsImageHolder::Options.new({ :image_field => 'my_field',
                                            :image_type_field => 'my_field_type',
                                            
                                            :resize_to => '400x300',
                                            :convert_to => :jpg,
                                            :allowed_types => [:png, 'gif', 'JPEG'],
                                            :maximum_bytes => 2.kilobytes,
                                            :jpeg_quality => 90,
                                            
                                            :thumb_field => 'my_field_thumb',
                                            :thumb_size => '40x30'
                                          })
    end
    
    it "should have 1 field" do 
      @o.should have(1).field
    end
    
    describe "field" do 
      before :each do 
        @f = @o.fields.first
      end
      
      it do 
        @f.image_field.should == 'my_field'
      end
      
      it do 
        @f.image_type_field.should == 'my_field_type'
      end
      
      it do 
        @f.resize_to.should == [400, 300]
      end
      
      it do 
        @f.convert_to.should == :jpeg
      end
      
      it do 
        @f.allowed_types.should == [:png, :gif, :jpeg]
      end
      
      it do 
        @f.maximum_bytes.should == 2048
      end
      
      it do 
        @f.jpeg_quality.should == 90
      end
      
      it do 
        @f.thumb_field.should == 'my_field_thumb'
      end
      
      it do 
        @f.thumb_size.should == [40, 30]
      end
    end
  end
  
  describe "several image-fields definition" do 
    before :each do 
      @o = ActsAsImageHolder::Options.new({ :image_fields => [{ :image_field => 'field1' },
                                                              { :image_field => 'field2' }
                                                             ]
                                          })
    end
    
    it do 
      @o.should have(2).fields
    end
    
    describe "first field" do 
      before :each do 
        @f = @o.fields.first
      end
      
      it do 
        @f.image_field.should == 'field1'
      end
    end
    
    describe "second field" do 
      before :each do 
        @f = @o.fields.last
      end
      
      it do 
        @f.image_field.should == 'field2'
      end
    end
  end
  
  describe "directory options" do 
    describe "absolute path" do 
      before :each do 
        @o = ActsAsImageHolder::Options.new({:output_directory => '/asdf/asdf', :subdirectories => 'asdf'})
      end
      
      it do 
        @o.output_directory.should == '/asdf/asdf'
      end
      
      it do 
        @o.subdirectories.should == 'asdf'
      end
    end
    
    describe "relative path" do 
      before :each do 
        @o = ActsAsImageHolder::Options.new(:output_directory => 'uploads')
      end
      
      it do 
        @o.output_directory.should == "#{RAILS_ROOT}/public/images/uploads"
      end
    end
  end
end
