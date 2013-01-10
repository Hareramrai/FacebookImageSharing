=begin

  @File Name                 : image.rb
  @Company Name              : Mindfire Solutions
  @Creator Name              : Hare Ram Rai
  @Date Created              : 15-12-2012
  @Date Modified             : 10-01-12013
  @Last Modification Details : added association
  @Purpose                   : To manage the image model

=end
class Image < ActiveRecord::Base  
  
  attr_accessible :picture, :verified, :category, :tags, :user_id, :category_id
    
  has_attached_file :picture,
    :storage => :dropbox,
    :dropbox_credentials => "#{Rails.root}/config/dropbox.yml",
    :styles => { :medium => "300x300" , :thumb => "100x100>"},
    :dropbox_options => {
      :path => proc { |style| "#{style}/#{id}_#{picture.original_filename}"},
      :unique_filename => true
    }

######################################################################################################################
#           VALIDATION STARTS HERE                                                                                   #
######################################################################################################################

    validates :picture, :attachment_presence => true
    validates :tags, :presence =>true
    validates :category, :presence => true
   
######################################################################################################################
#            VALIDATION ENDS HERE                                                                                    #
######################################################################################################################
 
##########################
#Defining Associations   #
##########################

  belongs_to :user
  belongs_to :category
  has_many :image_downloads
  has_many :image_views
  has_many :image_shares  

##########################
#End Defining Associations
##########################  
   
end # end of class
