class UsersController < ApplicationController

  before_action :layer_platform, only: [:create]

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
    params.require(:user).permit(:avatar, :first_name, :last_name, :username)
  end
end
