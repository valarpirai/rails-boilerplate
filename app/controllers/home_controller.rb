class HomeController < ApplicationController
    def index
        redirect_to user_session_path unless current_user
    end
end
