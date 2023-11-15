class ApplicationController < ActionController::Base
    before_action :set_breadcrumbs
    

    def is_logged_in
        if !session[:user_id].present?
            redirect_to "/login"
        end
    end

    def add_breadcrumb(label, path = nil)
        @breadcrumbs << {
            label: label,
            path: path
        }
    end

    def set_breadcrumbs
        @breadcrumbs = []
    end
end
