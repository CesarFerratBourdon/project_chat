class ItemsController < ApplicationController
  def create
    @item = Item.create( user_params )
  end

private

  def user_params
    #add the rest of the parameters
    params.require(:user).permit(:picture)
  end
end
