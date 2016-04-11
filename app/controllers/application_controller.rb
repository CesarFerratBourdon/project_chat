class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up)        { |u| u.permit(:username, :email, :password, :password_confirmation, :avatar, :remember_me) }
    devise_parameter_sanitizer.permit(:sign_in)        { |u| u.permit(:login, :username, :email, :password, :avatar, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password, :avatar) }
  end


  private

  def layer_platform
    @layer_platform ||= Layer::Platform::Client.new
    @layer_platform
  end

  def require_user_signed_in
    unless user_signed_in?

      # If the user came from a page, we can send them back.  Otherwise, send
      # them to the root path.
      if request.env['HTTP_REFERER']
        fallback_redirect = :back
      elsif defined?(root_path)
        fallback_redirect = root_path
      else
        fallback_redirect = "/"
      end
      respond_to do |format|
        format.html { redirect_to fallback_redirect, flash: { error: 'You must be signed in to view this page.' } }
        format.json { render json: { error: 'You must be signed in to view this page' }, status: :bad_request }
    end
  end

end
