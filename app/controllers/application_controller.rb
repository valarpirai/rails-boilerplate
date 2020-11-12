# Base class for Controllers
class ApplicationController < ActionController::Base
  layout :choose_layout

  include Concerns::ApplicationLayoutConcern
  include Concerns::ApplicationConcern
  include Concerns::ApplicationErrorHandlers

  # Throw exception
  # ActionController::Parameters.action_on_unpermitted_parameters = :raise
  # rescue_from(ActionController::UnpermittedParameters) do |pme|
  #   render json: { error: { unknown_parameters: pme.params } }, status: :bad_request
  # end

  # before_action :before_load_object, :load_object, :after_load_object, expect: 
end
