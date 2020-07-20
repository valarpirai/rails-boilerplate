# Base class for Controllers
class ApplicationController < ActionController::Base
  layout :choose_layout

  include Concerns::ApplicationLayoutConcern

  # Throw exception
  # ActionController::Parameters.action_on_unpermitted_parameters = :raise
  # rescue_from(ActionController::UnpermittedParameters) do |pme|
  #   render json: { error: { unknown_parameters: pme.params } }, status: :bad_request
  # end
end
