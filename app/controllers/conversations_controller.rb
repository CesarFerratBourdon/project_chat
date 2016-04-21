class ConversationsController < ApplicationController

  before_action :layer_platform

  def index
      @user = current_user
      @conversations = platform.users.find(@user.id).conversations.list #retieving all conversations for this user on Layer
      @conversations.each do |conv|
        conv.
      end
  end

  def show
      @user = current_user
      @conversation = Conversation.find_by(:conversation_id => params[:conv_id])
      @client = Client.find_by(:conversation_id => params[:conv_id])
      @conv = platform.users.find(@user.id).conversations.find(@conversation.conversation_id).messages.list #retrieving specific conversation from Layer
      respond_to do |format|
          format.js
      end
  end

  def create
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

      if @conv = platform.conversations.create(conversation)  #conversation is created in Layer
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

        platform.conversations.find(@conversation.conversation_id).messages.create(message)

      end
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

      conv = platform.conversations.find(params[:conversation_id])
      conv.messages.create(message)

    end


end
