# Include hook code here

if defined? I18n
  I18n.load_path.unshift Dir[ File.join(File.dirname(__FILE__), 'locales', '*.{rb,yml}') ]
end

require 'acts_as_image_holder'

class ActiveRecord::Base
  extend ActsAsImageHolder
end
