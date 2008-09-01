require 'active_record'

class CreateImageWithSeveralFieldsTable < ActiveRecord::Migration
  def self.up
    create_table "image_with_several_fields", :force => true do |t|
      t.binary :image1
      t.binary :image1_thumb1
      t.binary :image1_thumb2
      t.binary :image1_thumb3
      
      t.binary :image2
      t.binary :image2_orig
      t.binary :image2_thumb
      
      t.binary :image4
      t.binary :image4_thumb
    end
  end
  
  def self.down
    drop_table "blobbed_images"
  end
end
