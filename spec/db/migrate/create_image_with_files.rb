require 'active_record'

class CreateImageWithFilesTable < ActiveRecord::Migration
  def self.up
    create_table "image_with_files", :force => true do |t|
      t.binary :image_file
      t.binary :image_type
      t.binary :image_thumb_file
    end
  end
  
  def self.down
    drop_table "blobbed_images"
  end
end
