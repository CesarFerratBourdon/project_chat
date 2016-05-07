class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :layer_platform


  def create_conversation
      @conversation = Conversation.new
      @client = Client.last
      @client_id = @client.id
      @conversation.client_id = @client_id

      @minimum_client = User.minimum(:count_client)
      @user = User.where(:count_client => @minimum_client).first  #picking up the stylist with the least client yet
      @user_id = @user.id
      @conversation.user_id = @user_id

      conversation = {
        participants: [
          @client_id.to_s,
          @user_id.to_s
        ],
        distinct: true,
        metadata: {
          background_color: "#3c3c3c"
        }
      }

      if @conv = @layer_platform.conversations.create(conversation)  #conversation is created in Layer
        @conversation.conversation_id = @conv.uuid  #conversation id sent back from the 201 response from Layer
        @conversation.save
        @user.increment!(:count_client, 1)

        message = {
          sender: {
            name: @client.first_name
          },
          parts: [
            {
                body: "Hello " + @user.first_name + ", I am new to Project XY and would like to get your fashion advices. Thank you",
                mime_type: "text/plain"
            }
          ],
          notification: {
            text: "You have a new message",
            sound: "chime.aiff"
          }
        }

        @layer_platform.conversations.find(@conversation.conversation_id).messages.create(message)

      end
    end


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

end
