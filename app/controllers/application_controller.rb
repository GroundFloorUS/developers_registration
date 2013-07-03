class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_basic_auth

  protected

  # rescue_from CanCan::AccessDenied do |exception|
  #   redirect_to root_url, :alert => exception.message
  # end

  def authenticate_basic_auth
    auth = authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == "b1gm0n3y"
    end if Rails.env.downcase == "production"
  end
  
  def after_sign_in_path_for(resource)
    if resource.is_a? AdminUser
      admin_dashboard_path(resource) 
    else
      if (current_user)
        current_user.registation_url
      else
        root_path
      end
    end
  end
  
  
end
