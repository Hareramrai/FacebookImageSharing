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

    validates :picture, :attachment_presence => true
    validates :tags, :presence =>true
    validates :category, :presence => true
    
    belongs_to :user
end
