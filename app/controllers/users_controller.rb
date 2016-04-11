class UsersController < ApplicationController

  require_user_signed_in

  before_action :layer_platform, only: [:create]
  # after_action :token_generator, only: [:create]    IN PRODUCTION


  #IN PRODUCTION
  #Once you are ready for production implementation, you will need to write your own backend controller
  #to generate an identity token. check this https://github.com/layerhq/layer-identity-token-ruby
  #https://github.com/dreimannzelt/layer-identity_token

  # def token_generator
  #   @user = User.last
  #   @user_id = @user.id.to_s
  #   @token = @layer_platform.generate_identity_token(user_id: @user_id, nonce: "your_random_nonce")
  #   @token = @token.to_s
  #   @user = User.last
  #   @user.update(id_token: @token)
  # end

  def update
    return unless user_is_editing_self
    respond_to do |format|
      if @user.update(user_update_params)
        format.html { redirect_to dashboard_path, flash: { notice: 'Account successfuly changed' } }
        format.json { render json: @user }
      else
        respond_to_validation_error(format: format, model: @user)
      end
    end
  end


private

  def user_is_editing_self
    @user = User.find(params[:id])
    return true unless @user != current_user
    respond_to do |format|
      format.html { redirect_to :back, flash: { error: 'Error.  You cannot edit users that are not yourself' } }
      format.json { render json: { error: 'Error.  You cannot edit users that are not yourself' }, status: :bad_request }
    end
    false
  end

  def user_update_params
    params.require(:user).permit(:avatar, :first_name, :last_name, :username, :id_token)
  end
end
