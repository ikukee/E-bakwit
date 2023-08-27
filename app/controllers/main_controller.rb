class MainController < ApplicationController
   #before_action :is_logged_in, except: %i[login logout register login_proceed register_proceed index]
    def index
        @evac_centers = EvacCenter.all
    end

    def login

    end
    
    def logout
        session[:user_id] = nil
        session[:user_type] = nil
        redirect_to "/login"
    end

    def detailed_view
        
    end

    def evac_essentials_form
        
    end

    def evac_facilities_form
        
    end

    def log_relief_form
        
    end

    def login_proceed
        user = User.find_by(email: params[:email])
        respond_to do |format|
            if user.present?
                if user.authenticate(params[:password])
                    session[:user_id] = user.id
                    session[:user_type] = user.user_type
                    if user.user_type == "ADMIN"
                        format.html{redirect_to "/evac_centers"}
                    else
                        format.html{redirect_to "/dashboard"}
                    end
                    
                else
                    format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea", "<ul><li id = 'errMsg' style = 'color:red;'>INCORRECT PASSWORD!</li></ul>")}
                end
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea", "<ul><li id = 'errMsg' style = 'color:red;'>ACCOUNT NOT FOUND!</li></ul>")}
            end
        end
    end

    def logEvacuee
        
    end


    def register_proceed
        @user = User.new
        @user.username = params[:user][:register_username]
        puts @user.username
        @user.password_digest = params[:user][:password_digest]
        @user.status = "UNSUBSCRIBED"
        respond_to do |format|
            if @user.valid?
                if @user.password_digest == params[:user][:confirm_password]
                    @user.password_digest = BCrypt::Password.create(@user.password_digest)
                    @user.save
                    session[:user_id] = @user.id
                    session[:user_status] = @user.status
                    format.html{redirect_to "/account_details/subscribe"}
                else
                    format.turbo_stream{render turbo_stream: turbo_stream.update("registration_area", partial: "registration_form", locals:{user: @user, notice: "Password did not match!"})}
                end
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("registration_area", partial: "registration_form", locals:{user: @user, notice: ""})}
            end
        end
    end

    def send_request_proceed
        @request = Request.new
     
        @request.fname = params[:request][:fname].upcase
        @request.lname = params[:request][:lname].upcase
        @request.bdate = params[:request][:bdate]
        @request.email = params[:request][:email]
        @request.cnum = params[:request][:cnum]
        @request.request_date = Date.today()
        @request.address = params[:request][:address].upcase
        @request.images.attach(params[:request][:valid_id])
        @request.images.attach(params[:request][:selfie])
        @request.status = "PENDING"
        
        respond_to do |format|
            if @request.valid?
                if params[:request][:valid_id] == nil || params[:request][:selfie] == nil
                    format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea","Both IDs are required.")}
                else
                    @request.save
                    format.html{redirect_to "/login"}
                end
                
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("request_form",partial:"reqCreate_form",locals:{request:@request})}
            end
        end

    end

    def volunteer_requests

    end


end
