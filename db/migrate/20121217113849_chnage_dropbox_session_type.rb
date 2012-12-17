class ChnageDropboxSessionType < ActiveRecord::Migration
  def up
    remove_column(:users,:dropbox_secret,:dropbox_token)
    add_column  :users, :dropbox_session,:binary
  end
end
