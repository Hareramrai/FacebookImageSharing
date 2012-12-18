
# Get your app key and secret from the Dropbox developer website
DROPBOX_APP_KEY        = "o98jhe7nfzsgsg6"
DROPBOX_APP_KEY_SECRET = "djvj8xhctirk4z0"
DROPBOX_APP_MODE       = "dropbox" # if you have a single-directory app or "dropbox" if it has access to the whole dropbox

 FROM_SESSION = DropboxSession.new(DROPBOX_APP_KEY, DROPBOX_APP_KEY_SECRET)
 FROM_SESSION.set_access_token(*["o8w6mr7o9xsoivm","b9y0zhe1pv320a6"])
 FROM_CLIENT = DropboxClient.new(FROM_SESSION, DROPBOX_APP_MODE)