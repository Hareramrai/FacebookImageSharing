class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title  
      t.timestamps
    end
    
    add_column :images, :category_id, :integer 
    remove_column :images, :category
    
  end
end
