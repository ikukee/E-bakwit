class ApplicationController < ActionController::Base
    Mime::Type.register "application/xlsx", :xlsx
    before_action :set_breadcrumbs
    before_action :add_year
    before_action :timeout, 

    def timeout
        if session[:time_out_date]!= nil
            date = session[:time_out_date].split("-")
            year = date[0]
            month = date[1]
            day = date[2]
            timeout_date = Date.new(year.to_i,month.to_i,day.to_i)
            if Date.today >= timeout_date  
                session[:user_type]
                session[:user_id]
                session[:time_out_date] = nil
                redirect_to "/login"
            end
        end
    end

    def checkValidUser
        if session[:user_type] == "VOLUNTEER" || session[:user_type] == "CAMP MANAGER"
           redirect_to "/error"
        end

    end

    def add_year
        latest_year = Year.all.last
        currentYear = Date.today.year.to_s
        if latest_year.year.to_i < currentYear.to_i
            while latest_year.year.to_i < currentYear.to_i
                year = Year.new
                year.year = (latest_year.year.to_i + 1).to_s
                year.save
                latest_year = Year.all.last
            end
        end
    end

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
