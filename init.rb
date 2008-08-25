# Include hook code here
require 'acts_as_image_holder'

class ActiveRecord::Base
  extend ActsAsImageHolder
end
