module Concerns::ApplicationErrorHandlers
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::RoutingError, with: :record_not_found
    
  end

  private

  def render_404
    render file: "#{Rails.root}/404", formats: [:html], status: :not_found, layout: false
  end

  JSON_404 = {errors: {error: "Record Not Found"}}.to_json
  def record_not_found(exception = nil)
    respond_to do |format|
      format.html {
        unless @current_account
          render("/errors/invalid_domain", layout: false)
        else
          render_404
        end
      }
      format.json do
        render json: JSON_404, status: :not_found
      end
      format.nmobile do
        render json: JSON_404, status: :not_found
      end
      format.widget do
        render json: JSON_404, status: :not_found
      end
    end
  end

end
