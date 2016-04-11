class ConversationsController < ApplicationController

  before_action :layer_platform, only: [:create]

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

    if platform.conversations.create(conversation)  #conversation is created in Layer
      @conversation.conversation_id = response.id  #conversation id sent back from the 201 response from Layer
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

      conv = platform.conversations.find(@conversation.conversation_id)
      conv.messages.create(message)

    end




  end


end
