class HomeController < ApplicationController
    def index
        redirect_to '/login'
    end
end
