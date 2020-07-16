class ApplicationController < ActionController::Base
    layout :choose_layout

    include Concerns::ApplicationLayoutConcern

    def current_user
        nil
    end
end
