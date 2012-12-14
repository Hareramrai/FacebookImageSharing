class UsersController < ApplicationController
  
  def my_uploads
      @images = current_user.images  
  end
  
  def show    
    @user = FbGraph::User.me(current_user.auth_token).fetch    
  end
  
  def authorize
    consumer = Dropbox::API::OAuth.consumer(:authorize)
    session[:request_token] = consumer.get_request_token
    redirect_to session[:request_token].authorize_url(:oauth_callback => "http://192.168.9.247:3000/users/dropbox_callback")
    
  end

  def dropbox_callback  
    
    access = session[:request_token].get_access_token(:oauth_verifier => params[:oauth_token])     
    current_user.update_attributes(:dropbox_token =>access.params[:oauth_token],:dropbox_secret => access.params[:oauth_token_secret] )              
    redirect_to images_path
  end
  
  def dropbox_download
    
    @client = Dropbox::API::Client.new(:token  => current_user.dropbox_token, :secret => current_user.dropbox_secret)
    id = request.env["HTTP_REFERER"].split("/").last
    image = Image.find_by_id(id)
    filename= File.join(Rails.root,"public",Time.now.to_i.to_s+"."+image.picture_file_name.split(".").last)
    require 'open-uri'
    open(filename, 'wb') do |file|
      file << open(image.picture.url).read
    end
    
    data = File.read(filename)
    
    @client.upload filename, data
    
    redirect_to request.referrer
  end
end