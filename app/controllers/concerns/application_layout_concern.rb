# frozen_string_literal: true
module Concerns::ApplicationLayoutConcern
  extend ActiveSupport::Concern

  CACHE_BUSTER_HEADERS = {
    'Cache-Control' => 'no-cache, no-store, max-age=0, must-revalidate',
    'Pragma' => 'no-cache',
    'Expires' => 'Fri, 01 Jan 1990 00:00:00 GMT'
  }

  IFRAME_HEADER = 'X-Frame-Options'

  PJAX_HEADER = 'X-PJAX'
  MAINCONTENT_LAYOUT = 'maincontent'
  APPLICATION_LAYOUT = 'application'
  PUBLIC_LAYOUT = 'public'
  PRINT_LAYOUT = 'print'

  private

  def choose_layout
    return PUBLIC_LAYOUT unless current_user
    pjax_request? ? MAINCONTENT_LAYOUT : APPLICATION_LAYOUT
  end

  def pjax_request?
    request.headers[PJAX_HEADER]
  end
end
