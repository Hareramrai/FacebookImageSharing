=begin

  @File Name                 : user.rb
  @Company Name              : Mindfire Solutions
  @Creator Name              : Hare Ram Rai
  @Date Created              : 15-12-2012
  @Date Modified             :
  @Last Modification Details :
  @Purpose                   : To manage the user

=end
class User < ActiveRecord::Base
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, 
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable ,:lockable, :timeoutable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :auth_token ,  :provider, :uid, :facebook_image, :dropbox_session
  
  
  ##########################
  #Defining Associations   #
  ##########################
  
  has_many :images   
  has_many :image_downloads
  has_many :image_views
  has_many :image_shares
  
  ##########################
  #End Defining Associations
  ##########################
  
  # @Params  : auth
  # @Return  : user
  # @Purpose : To find or create new user from facebook oauth
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    
    user = User.where(:email => auth.info.email, :uid => auth.uid).first
    
    unless user
     user = User.create(:uid => auth.uid,
        :email => auth.info.email,
        :facebook_image => auth.info.image,
        :auth_token => auth.credentials.token,
        :name =>  auth.info.name,
        :password => Devise.friendly_token[0,20]
      )
      
    else
        
      user.update_attributes(:auth_token => auth.credentials.token , :facebook_image => auth.info.image)
        
    end
      
    user
      
  end # end of find_for_facebook_oauth

  # @Params  : None
  # @Return  : None
  # @Purpose : To check admin user type
  def admin?

    self.is_admin

  end # end of admin
  
  # @Params  : user_id,image_id
  # @Return  : None
  # @Purpose : To download the image to dropbox
  def download_to_dropbox(user_id,image_id)
    
    current_user = User.find_by_id(user_id)    
    dbsession = DropboxSession.deserialize(current_user.dropbox_session)
    # create the dropbox client object
    to_client = DropboxClient.new(dbsession, ENV["DROPBOX_APP_MODE"])     
    
    # fetch the image from image_id
    image = Image.find_by_id(image_id)    
    
    # get the image path
    path = image.picture.url.split("/")[5..6].join("/")
    
    #set the from_path
    from_path = "Public/#{path}"
    to_path = 	"/#{path}"
    copy_ref = FROM_CLIENT.create_copy_ref(from_path)['copy_ref']
    metadata = to_client.add_copy_ref(to_path, copy_ref)	
	
  end # end of download_to_dropbox
    
end # end of class
