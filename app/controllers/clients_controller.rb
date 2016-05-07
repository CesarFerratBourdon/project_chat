class ClientsController < ApplicationController

  before_action :layer_platform, only: [:create]
  # after_action :token_generator, only: [:create]    IN PRODUCTION

  def create
    # respond_to do |format|
      @client = Client.new(client_params) #client_params have to be extracted from Json from IOS registration
      if @client.save
        # format.json { render json: @client, status: :created }

        create_conversation

      else
        respond_to_validation_error(format: format, model: @client)
      end
    # end
  end

  #IN PRODUCTION
  #Once you are ready for production implementation, you will need to write your own backend controller
  #to generate an identity token. check this https://github.com/layerhq/layer-identity-token-ruby
  #https://github.com/dreimannzelt/layer-identity_token

  # def token_generator
  #   @client = Client.last
  #   @user_id = @client.id.to_s
  #   @token = @layer_platform.generate_identity_token(user_id: @user_id, nonce: "your_random_nonce")
  #   @token = @token.to_s
  #   @client.update(id_token: @token)
  # end


  def update
    respond_to do |format|
      if @client.update(client_update_params)
        format.html { redirect_to @clients, notice: 'Client was successfully updated.' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:first_name, :last_name, :age, :address, :city, :state, :zip_code, :phone_number, :email)
    end

    def client_update_params
      params.require(:client).permit(:first_name, :last_name, :age, :address, :city, :state, :zip_code, :phone_number, :email, :id_token, :avatar)
    end

end
