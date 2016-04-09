class ClientsController < ApplicationController
  
  before_action :layer_platform, only: [:create]

end
