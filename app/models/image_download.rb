=begin

  @File Name                 : image_download.rb
  @Company Name              : Mindfire Solutions
  @Creator Name              : Hare Ram Rai
  @Date Created              : 10-01-2013
  @Date Modified             :
  @Last Modification Details :
  @Purpose                   : To manage the image download model

=end

class ImageDownload < ActiveRecord::Base
  
  # attribute accessible fields are
  attr_accessible :image_id, :user_id, :created_at, :id
  
  ##########################
  #Defining Associations   #
  ##########################
  
    belongs_to :user
    belongs_to :image
    
  ##########################
  #End Defining Associations
  ##########################  
  
end
