require 'active_record'

class CreateImageWithBlobsTable < ActiveRecord::Migration
  def self.up
    create_table "image_with_blobs", :force => true do |t|
      t.binary :image
      t.binary :image_type
      t.binary :image_thumb
    end
  end
  
  def self.down
    drop_table "image_with_blobs"
  end
end
