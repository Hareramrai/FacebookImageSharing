class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.attachment :picture
      t.boolean :verified , :default => false
      t.string :category
      t.string :tags
      t.timestamps
      t.timestamps
    end
  end
end
