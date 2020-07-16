class HomeController < ApplicationController
    def index
        redirect_to user_session_path
    end
end
