=begin

  @File Name                 : omniauth_callbacks_controller.rb
  @Company Name              : Mindfire Solutions 
  @Creator Name              : Hare Ram Rai
  @Date Created              : 15-12-2012
  @Date Modified             :
  @Last Modification Details :
  @Purpose                   : To manage the omniauth callbacks

=end

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  
  # @Params  : request
  # @Return  : None
  # @Purpose : To sign in the user 
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    
    #checking for already existed user
    if @user.persisted?
      
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      
    else
      
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to root_url
      
    end #end of if
    
  end # end of facebook action
  
  
end # end of class