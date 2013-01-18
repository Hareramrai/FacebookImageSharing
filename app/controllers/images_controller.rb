=begin

  @File Name                 : images_controller.rb
  @Company Name              : Mindfire Solutions 
  @Creator Name              : Hare Ram Rai
  @Date Created              : 15-12-2012
  @Date Modified             :
  @Last Modification Details :
  @Purpose                   : To manage the images

=end

class ImagesController < ApplicationController
  
  # for user authentication 
  before_filter :authenticate_user!, :except => [:index,:search]
  #load_and_authorize_resource
  load_and_authorize_resource :except => [:search]

  
  # @Params  : None
  # @Return  : None
  # @Purpose : To display all the images
  def index
    
    #fetch the all images
    @images = Image.includes(:category).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @images }      
    end
    
  end # end of index action

 
  # @Params  : params[:id]
  # @Return  : None
  # @Purpose : To show the a image   
  def show
    
    # find the image by id
    @image = Image.find(params[:id])
    ImageView.find_or_create_by_user_id_and_image_id(current_user.id,@image.id)
    PrivatePub.publish_to("/messages/new", message: @image)
          
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @image }
    end
    
  end # end of show action

  
  # @Params  : None
  # @Return  : None
  # @Purpose : To display a form for creating image
  def new
    
    @image = Image.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @image }
    end
    
  end # end of new action
  
  # @Params  : params[:id]
  # @Return  : None
  # @Purpose : To edit the image
  def edit
    
    @image = Image.find(params[:id])
    
  end # end of edit action

  
  # @Params  : params[:image]
  # @Return  : None
  # @Purpose : To create the new image object
  def create
    
    # create the image with params[:image]
    @image = Image.new(params[:image])
    
    #set the user_id of image with current user id
    @image.user_id = current_user.id
    
    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render json: @image, status: :created, location: @image }
      else
        format.html { render action: "new" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
    
  end # end of create action

 
  # @Params  : params[:id]
  # @Return  : None
  # @Purpose : To update the image object
  def update
    
    # find the image with params[:id]
    @image = Image.find(params[:id])
    
    #set the user_id of image with current user id
    @image.user_id = current_user.id
    
    respond_to do |format|
      
      if @image.update_attributes(params[:image])
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
      
    end
    
  end # end of update action

 
  # @Params  : params[:id]
  # @Return  : None
  # @Purpose : To delete the image 
  def destroy
    
    # find the image with params[:id]
    @image = Image.find(params[:id])
    
    #delete the image
    @image.destroy

    respond_to do |format|
      
      format.html { redirect_to images_url }
      format.json { head :no_content }
      
    end
    
  end # end of destroy action

  # @Params  : None
  # @Return  : None
  # @Purpose : To search the image based on key or category
  def search
    
    if params[:id] == "search"
      
      # find the related image to params[:key]
      @images = Image.where("tags LIKE ? OR  picture_file_name LIKE ?", "%#{params[:key]}%", "%#{params[:key]}%")      
      
    else
      
      # find the image by category 
      @images = Image.where("category_id = ?",params[:id])      
      
    end
    
    respond_to do |format|
      
      format.html { render "index"}
      format.json { render json: @images }
      
    end
    
  end # end of search action
  
end # end of class
