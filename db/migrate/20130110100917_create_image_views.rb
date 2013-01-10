class CreateImageViews < ActiveRecord::Migration
  def change
    create_table :image_views do |t|
      t.references   :image
      t.references   :user  
      t.timestamps
    end
  end
end
