=begin

  @File Name                 : users_controller.rb
  @Company Name              : Mindfire Solutions
  @Creator Name              : Hare Ram Rai
  @Date Created              : 15-12-2012
  @Date Modified             :
  @Last Modification Details :
  @Purpose                   : To manage the dividend part

=end

require 'dropbox_sdk'

class UsersController < ApplicationController
  
  # @Params  : None
  # @Return  : None
  # @Purpose : To list the all my uploaded images
  def my_uploads
    
    @images = current_user.images  
      
  end # end of my_uploads
  
  # @Params  : None
  # @Return  : None
  # @Purpose : To display all the details of the current user  
  def show    
    
    @user = FbGraph::User.me(current_user.auth_token).fetch    
    
  end # end of show action
  
  # @Params  : None
  # @Return  : None
  # @Purpose : To create new dropbox session for authorization
  def authorize
    
    dbsession = DropboxSession.new(ENV["DROPBOX_APP_KEY"],ENV["DROPBOX_APP_KEY_SECRET"])
    #serialize and save this DropboxSession
    session[:dropbox_session] = dbsession.serialize     
    #pass to get_authorize_url a callback url that will return the user here
    redirect_to dbsession.get_authorize_url url_for(:action => 'dropbox_callback')
    
  end
  
  # @Params  : None
  # @Return  : None
  # @Purpose : To callback for dropbox authorization
  def dropbox_callback  
    
    dbsession = DropboxSession.deserialize(session[:dropbox_session])
    dbsession.get_access_token  #we've been authorized, so now request an access_token
    session[:dropbox_session] = dbsession.serialize      
    current_user.update_attributes(:dropbox_session=> session[:dropbox_session])
    session.delete :dropbox_session
    flash[:success] = "You have successfully authorized with dropbox."
    
    redirect_to images_path
    
  end # end of dropbox_callback action
  
  # @Params  : None
  # @Return  : None
  # @Purpose : To 
  def dropbox_download
    
   id = request.env["HTTP_REFERER"].split("/").last   
   current_user.download_to_dropbox(current_user.id,id)   
   
   # create image download record 
   ImageDownload.create(:user_id => current_user.id, :image_id => id )
    
   # fetch the new record for images viewed by category
    categories = ImageDownload.joins("JOIN images on  image_downloads.`image_id` = images.`id` RIGHT JOIN categories on categories.`id` = images.`category_id`").group("categories.id").
     select('categories.title as title,count(image_downloads.id) as count').order("categories.title")

    # push the new data to the byimagedownloads channel        
    PrivatePub.publish_to("/notifications/byimagedownloads","updateImageDownloads(#{categories.to_json})")
           
   flash[:success] = "The image is successfully downloaded in your dropbox."
   
   redirect_to request.referrer
    
  end # end of dropbox_download action
  
end # end of class
