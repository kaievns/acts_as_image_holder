require 'spec'
require 'active_record'

unless defined? ActsAsImageHolder
  require File.dirname(__FILE__)+"/../lib/acts_as_image_holder"
  require File.dirname(__FILE__)+"/../lib/acts_as_image_holder/options"
end
