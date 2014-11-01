class ConfirmationsController < Devise::ConfirmationsController
  protected

  def after_confirmation_path_for(_resource_name, resource)
    stored_location_for(resource) || root_path
  end
end
