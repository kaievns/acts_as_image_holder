require 'spec'
require 'active_record'

unless defined? ActsAsImageHolder
  require File.dirname(__FILE__)+"/../lib/acts_as_image_holder"
  require File.dirname(__FILE__)+"/../lib/acts_as_image_holder/options"
  require File.dirname(__FILE__)+"/../lib/acts_as_image_holder/file_proc"
  require File.dirname(__FILE__)+"/../lib/acts_as_image_holder/image_proc"
  
  class ActiveRecord::Base
    extend ActsAsImageHolder
  end

end

# configuration of the test database environoment
$db_file = File.dirname(__FILE__)+"/db/test.sqlite3"
unless ActiveRecord::Base.connected?
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => $db_file)
end

# run mibrations
unless File.exists?($db_file)
  require File.dirname(__FILE__)+"/db/migrate/create_images.rb"
  CreateImagesTable.migrate(:up)
end
