class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # TEMPORARILY DISABLED FOR DEVELOPMENT - uncomment when ready for auth
  # before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  include Pundit::Authorization
  
  # TEMPORARILY DISABLED FOR DEVELOPMENT - uncomment when ready for auth
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  # Temporary method to simulate a current_user during development
  def current_user
    @current_user ||= User.first || create_temp_user
  end
  helper_method :current_user
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role, :phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :role, :phone])
  end
  
  private
  
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
  
  # Temporary helper for development
  def create_temp_user
    User.create!(
      email: "dev@raincrm.local",
      password: "password123",
      first_name: "Dev",
      last_name: "User",
      role: "loan_officer"
    )
  rescue ActiveRecord::RecordInvalid
    User.find_by(email: "dev@raincrm.local")
  end
end