require 'spec'
require 'active_record'

unless defined? ActsAsImageHolder
  require File.dirname(__FILE__)+"/../lib/acts_as_image_holder"
  require File.dirname(__FILE__)+"/../lib/acts_as_image_holder/options"
  require File.dirname(__FILE__)+"/../lib/acts_as_image_holder/file_proc"
  require File.dirname(__FILE__)+"/../lib/acts_as_image_holder/image_proc"
  require File.dirname(__FILE__)+"/../lib/acts_as_image_holder/image_proc/watermarker"
  
  class ActiveRecord::Base
    extend ActsAsImageHolder
  end

  require File.dirname(__FILE__)+"/../examples/image_with_blob"
  require File.dirname(__FILE__)+"/../examples/image_with_file"
  require File.dirname(__FILE__)+"/../examples/image_with_several_fields"
end

RAILS_ROOT = '' unless defined? RAILS_ROOT

  
# configuration of the test database environoment
$db_file = File.dirname(__FILE__)+"/db/test.sqlite3"
FileUtils.rm_rf($db_file)
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => $db_file)


# run mibrations
require File.dirname(__FILE__)+"/db/migrate/create_image_with_blobs.rb"
require File.dirname(__FILE__)+"/db/migrate/create_image_with_files.rb"
require File.dirname(__FILE__)+"/db/migrate/create_image_with_several_fields.rb"

ActiveRecord::Migration.verbose = false

CreateImageWithBlobsTable.migrate(:up)
CreateImageWithFilesTable.migrate(:up)
CreateImageWithSeveralFieldsTable.migrate(:up)


unless defined? ActionController
  module ActionController
    class UploadedStringIO < StringIO
    end
    
    class UploadedTempfile < Tempfile
    end
  end
end


$fixtures_dir = File.dirname(__FILE__)+"/fixtures"
