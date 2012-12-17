require 'dropbox_sdk'

class UsersController < ApplicationController
  
  def my_uploads
      @images = current_user.images  
  end
  
  def show    
    @user = FbGraph::User.me(current_user.auth_token).fetch    
  end
  
  def authorize
    
    dbsession = DropboxSession.new(DROPBOX_APP_KEY, DROPBOX_APP_KEY_SECRET)
    session[:dropbox_session] = dbsession.serialize #serialize and save this DropboxSession
    #pass to get_authorize_url a callback url that will return the user here
    redirect_to dbsession.get_authorize_url url_for(:action => 'dropbox_callback')
    
  end

  def dropbox_callback  
    
    dbsession = DropboxSession.deserialize(session[:dropbox_session])
    dbsession.get_access_token  #we've been authorized, so now request an access_token
    session[:dropbox_session] = dbsession.serialize      
    current_user.update_attributes(:dropbox_session=> session[:dropbox_session])
    session.delete :dropbox_session
    redirect_to images_path
  end
  
  def dropbox_download
    
    dbsession = DropboxSession.deserialize(current_user.dropbox_session)
    client = DropboxClient.new(dbsession, DROPBOX_APP_MODE) 
    logger.debug "@@@@@@@@ #{client.account_info}" 
    id = request.env["HTTP_REFERER"].split("/").last
    image = Image.find_by_id(id)
    filename= File.join(Rails.root,"public",Time.now.to_i.to_s+"."+image.picture_file_name.split(".").last)
    
    require 'open-uri'
    open(filename, 'wb') do |file|
      file << open(image.picture.url).read
    end    
    
    data = File.read(filename)
    
    logger.debug "@@@@@@@@#{filename}" 
    
    client.put_file(filename, data)        
    
    logger.debug "@@@@@@@@ #{client.account_info}" 
    
    redirect_to request.referrer
    
  end
  
end