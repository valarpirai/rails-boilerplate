# Base class for Controllers
class ApplicationController < ActionController::Base
  layout :choose_layout

  include Concerns::ApplicationLayoutConcern
  include Concerns::ApplicationConcern
  include Concerns::ApplicationErrorHandlers

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :set_current_account

  # Throw exception
  # ActionController::Parameters.action_on_unpermitted_parameters = :raise
  # rescue_from(ActionController::UnpermittedParameters) do |pme|
  #   render json: { error: { unknown_parameters: pme.params } }, status: :bad_request
  # end
end
