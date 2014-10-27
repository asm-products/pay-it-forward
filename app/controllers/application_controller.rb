class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  check_authorization unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    
    ::Rails.logger.debug "Request Path - - - - - - - '#{request.path}'"
    
    # Push Path
    store_location_for(:user, request.path) if request.path[/\/user\//].nil?
    
    # Sign Up
    next redirect_to new_user_session_path if current_user.nil?
    next redirect_to user_finish_sign_up_path unless current_user.email_verified?
    next redirect_to user_confirmation_path unless current_user.confirmed?
    
    # Insufficient Permissions
    redirect_to root_url, alert: exception.message
  end
  
  protected
  
  def after_sign_in_path_for(resource)
    ::Rails.logger.debug "after_sign_in_path_for - - - - - - - '#{resource}'"
    stored_location_for(resource) || root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
  end
  
end
