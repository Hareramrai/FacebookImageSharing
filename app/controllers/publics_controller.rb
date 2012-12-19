=begin

  @File Name                 : publics_controller.rb
  @Company Name              : Mindfire Solutions 
  @Creator Name              : Hare Ram Rai
  @Date Created              : 15-12-2012
  @Date Modified             :
  @Last Modification Details :
  @Purpose                   : To manage the public home page

=end

class PublicsController < ApplicationController
  
  # @Params  : None
  # @Return  : None
  # @Purpose : To display the home page of the application
  def index
    
    @images = Image.all
    
  end # end of index action
  
end # end of class
