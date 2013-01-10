class CreateImageDownloads < ActiveRecord::Migration
  def change
    create_table :image_downloads do |t|
      t.references   :image
      t.references   :user      
      t.timestamps
    end
  end
end
