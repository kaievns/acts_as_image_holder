require 'active_record'

class CreateBlobbedImagesTable < ActiveRecord::Migration
  def self.up
    create_table "blobbed_images", :force => true do |t|
      t.binary :image
      t.binary :image_type
      t.binary :image_thmb
    end
  end
  
  def self.down
    drop_table "blobbed_images"
  end
end
