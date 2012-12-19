=begin

  @File Name                 : image.rb
  @Company Name              : Mindfire Solutions
  @Creator Name              : Hare Ram Rai
  @Date Created              : 15-12-2012
  @Date Modified             :
  @Last Modification Details :
  @Purpose                   : To manage the image model

=end
class Image < ActiveRecord::Base  
  
  attr_accessible :picture, :verified, :category, :tags, :user_id
    
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
    
  ##########################
  #End Defining Associations
  ##########################  
  
  
  
end # end of class
