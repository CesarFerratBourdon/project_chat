class ConversationsController < ApplicationController

  before_action :layer_platform

  def index
      @user = current_user
      @conversations = @layer_platform.users.find(@user.id).conversations.list #retieving all conversations for this user on Layer

  end

  def show
      @user = current_user
      @conversation = Conversation.find_by(:conversation_id => params[:conv_id])
      @client = Client.find_by(:conversation_id => params[:conv_id])
      @conv = @layer_platform.users.find(@user.id).conversations.find(@conversation.conversation_id).messages.list #retrieving specific conversation from Layer
      respond_to do |format|
          format.js
      end
  end

  def create
    create_conversation
  end

    def send_message
      @user = current_user
      @message = input  #submited from form
      message = {
        sender: {
          name: @user.username
        },
        parts: [
          {
              body: @message,
              mime_type: "text/plain"
          },
          # {
          #     body: "YW55IGNhcm5hbCBwbGVhc3VyZQ==",
          #     mime_type: "image/jpeg",
          #     encoding: "base64"
          # }
        ],
        notification: {
          text: "You have a new message",
          sound: "chime.aiff"
        }
      }

      @conv = @layer_platform.conversations.find(params[:conversation_id])
      @conv.messages.create(message)
    end

end
