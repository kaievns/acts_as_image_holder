require File.dirname(__FILE__)+"/../../spec_helper"

describe ActsAsImageHolder::FileProc do 
  before :each do 
    @file = File.open(File.dirname(__FILE__)+"/../../images/test.jpg", 'rb')
    @options = ActsAsImageHolder::Options.new(:output_directory => "/tmp/images/spec",
                                              :subdirectories => "%Y-%m")
  end
  
  after :all do 
    FileUtils.rm_rf @options.output_directory
  end
  
  describe "file-name guess" do 
    before :each do 
      FileUtils.rm_rf @options.output_directory
      
      @file_name = ActsAsImageHolder::FileProc.guess_file_name @options, @file
    end
    
    it "shuold be a string" do 
      @file_name.should be_is_a(String)
    end
    
    it "should ends like the original filename" do 
      @file_name[-8, 8].should == 'test.jpg'
    end
    
    it "should start with the directory name" do 
      @file_name[0,8].should == Time.now.strftime("%Y-%m")+"/"
    end
    
    describe "file writting" do 
      before :each do 
        ActsAsImageHolder::FileProc.write_file(@options, @file_name, 'something')
        @full_name = @options.output_directory+"/"+@file_name
      end
      
      it "should exists" do 
        File.should be_exists(@full_name)
      end
      
      it "should contain the string" do 
        File.open(@full_name, 'rb').read.should == 'something'
      end
      
      describe "file removing" do 
        before :each do 
          ActsAsImageHolder::FileProc.remove_file(@options, @file_name)
        end
        
        it 'should not exists' do 
          File.should_not be_exists(@full_name)
        end
      end
    end
    
    describe "conflicted file name solving" do 
      before :each do
        ActsAsImageHolder::FileProc.write_file(@options, @file_name, 'something')
        @another_file_name = ActsAsImageHolder::FileProc.guess_file_name @options, @file
      end
      
      it "should not be the same" do 
        @another_file_name.should_not == @file_name
      end
    end
  end
  
  describe "thumb file-name guess" do 
    before :each do 
      FileUtils.rm_rf @options.output_directory
      
      @file_name = ActsAsImageHolder::FileProc.guess_thumb_file_name @options, @file
    end
    
    it 'should be a string' do 
      @file_name.should be_is_a(String)
    end
    
    it "should be similar to the original file name" do 
      @file_name.split('/').last.should == 'test-thumb.jpg'
    end
  end
end
