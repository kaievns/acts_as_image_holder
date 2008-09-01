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

end

RAILS_ROOT = '' unless defined? RAILS_ROOT

  
# configuration of the test database environoment
unless defined? $db_file
  $db_file = File.dirname(__FILE__)+"/db/test.sqlite3"
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => $db_file)
end


# run mibrations
unless File.exists?($db_file)
  require File.dirname(__FILE__)+"/db/migrate/create_blobbed_images.rb"
  require File.dirname(__FILE__)+"/db/migrate/create_image_with_files.rb"
  require File.dirname(__FILE__)+"/db/migrate/create_image_with_several_fields.rb"
  
  CreateBlobbedImagesTable.migrate(:up)
  CreateImageWithFilesTable.migrate(:up)
  CreateImageWithSeveralFieldsTable.migrate(:up)
end
