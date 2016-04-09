class ClientsController < ApplicationController

  before_action :layer_platform, only: [:create]
  # after_action :token_generator, only: [:create]    IN PRODUCTION

end
