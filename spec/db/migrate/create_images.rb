class CreateImagesTable < ActiveRecord::Migration
  def self.up
    create_table "images", :force => true do |t|
      t.binary :image
      t.binary :image_type
      t.binary :image_thmb
    end
  end
  
  def self.down
    drop_table "images"
  end
end
