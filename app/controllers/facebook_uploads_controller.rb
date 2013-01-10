=begin

  @File Name                 : facebook_uploads_controller.rb
  @Company Name              : Mindfire Solutions 
  @Creator Name              : Hare Ram Rai
  @Date Created              : 15-12-2012
  @Date Modified             :
  @Last Modification Details :
  @Purpose                   : To manage the image upload to facebook

=end

class FacebookUploadsController < ApplicationController
  
  # @Params  : None
  # @Return  : None
  # @Purpose : To display the tag user on the image with comment
  def new
    
    # get the image id from request.env["HTTP_REFERER"]
    @image_id = request.env["HTTP_REFERER"].split("/").last
    
    # fetch the user and its friends details
    facebook_user = FbGraph::User.me(current_user.auth_token).fetch
    @friends = facebook_user.friends   
    
    render :layout => false
    
  end
  
  # @Params  : params
  # @Return  : None
  # @Purpose : To  tag user on the image with comment  and upload it to facebook
  def create
    
    # find the image from the image_id
    @image = Image.find_by_id(params[:image_id])  
    
    # fetch the user details from the facebook
    me = FbGraph::User.me(current_user.auth_token)
    
    #create the array of friends uid
    friends = params[:friends].split(",")
    tags = []
    
    # looping through friends array 
    friends.each do |friend|
      
     #creating a new tag object  and add it to tag array
     tags << FbGraph::Tag.new(
                  :id => friend,
                  :name => "with Facebook profile link",
                  :x => 2*Random.rand(9),
                  :y => 9*Random.rand(2)
      )
      
    end # end of friends block
    
    # uploading the image the friends tag
    FbGraph::User.me(current_user.auth_token).photo!(
      :url => @image.picture.url ,
      :message => params[:message],
      :tags => tags
    )
    
    # create image share record 
    ImageShare.create(:user_id => current_user.id, :image_id => @image.id )
    
    flash[:success] = "Successfully uploaded and tagged the your friends."   
 
    redirect_to image_path(@image)
        
  end # end of create action 
      
end # end of class

