class DashboardController < ApplicationController

  def index
    @user = current_user
    # if user_signed_in?
    #   redirect_to :controller => 'conversations', :action => 'index'
    # end
  end

  def welcome
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

end
