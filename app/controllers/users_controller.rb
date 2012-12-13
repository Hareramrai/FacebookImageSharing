class UsersController < ApplicationController
  
  def my_uploads
      @images = current_user.images  
  end
  
  def show
    
    @user = FbGraph::User.me(current_user.auth_token).fetch
    
  end
end