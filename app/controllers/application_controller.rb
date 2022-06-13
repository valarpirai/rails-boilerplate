# Base class for Controllers
class ApplicationController < ActionController::Base
  layout :choose_layout

  include Concerns::ApplicationLayoutConcern
  include Concerns::ApplicationConcern
  include Concerns::ApplicationErrorHandlers

  before_action :authenticate_user!

  # TODO - Restrict only HTML response

  # Throw exception
  # ActionController::Parameters.action_on_unpermitted_parameters = :raise
  # rescue_from(ActionController::UnpermittedParameters) do |pme|
  #   render json: { error: { unknown_parameters: pme.params } }, status: :bad_request
  # end


  def ws_broadcast(client_id, env_config)
    ActionCable.server.broadcast "messages_#{client_id}", data: env_config, flag: env_config.feature_flag.name
  end
end
