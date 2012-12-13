class FacebookUploadsController < ApplicationController
  
  def new
    @image_id = request.env["HTTP_REFERER"].split("/").last
    facebook_user = FbGraph::User.me(current_user.auth_token).fetch
    @friends = facebook_user.friends   
    render :layout => false
  end
  
  def create
    @image = Image.find_by_id(params[:image_id])  #picture.url
    me = FbGraph::User.me(current_user.auth_token)
    friends = params[:friends].split(",")
    tags = []
    friends.each do |friend|
      
     tags << FbGraph::Tag.new(
                  :id => friend,
                  :name => "with Facebook profile link",
                  :x => 2*Random.rand(9),
                  :y => 9*Random.rand(2)
      )
      
    end
 
    FbGraph::User.me(current_user.auth_token).photo!(
      :url => @image.picture.url ,
      :message => 'Testing the facebook image upload application.',
      :tags => tags
    )
    
    flash[:success] = "Successfully uploaded and tagged the your friends."
    
    redirect_to root_path
        
  end
  
  
  
end