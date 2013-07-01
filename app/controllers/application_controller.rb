class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_basic_auth

  protected

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def authenticate_basic_auth
    auth = authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == "b1gm0n3y"
    end if Rails.env.downcase == "production"
  end
  
end
