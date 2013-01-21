class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
   redirect_to root_url, :alert => exception.message
  end
  # for getting all categories 
  before_filter :get_categories
  
  
  
  
  private 
  
  # @Params  : None
  # @Return  : None
  # @Purpose : To get all category
  def get_categories
    
    @categories = Category.includes(:images).order("categories.title")
    
  end
  
end
