class AddDropInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dropbox_secret, :string
    add_column :users, :dropbox_token, :string
  end
end
