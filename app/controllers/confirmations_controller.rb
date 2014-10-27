class ConfirmationsController < Devise::ConfirmationsController
  protected
  
  def after_confirmation_path_for(resource_name, resource)
    ::Rails.logger.debug "after_confirmation_path_for - - - - - - - '#{resource}'"
    stored_location_for(resource) || root_path
  end
end