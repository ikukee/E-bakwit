class MainController < ApplicationController
    before_action :is_logged_in, except: %i[login logout register login_proceed register_proceed index]
    def index
        @evac_centers = EvacCenter.all
    end

    def error

    end

    def login

    end

    def logout
        session[:user_id] = nil
        session[:user_type] = nil
        redirect_to "/login"
    end

    def account
        add_breadcrumb('Your Account')
        @user = User.find(session[:user_id])

    end

    def login_proceed
        user = User.find_by(email: params[:email])
        respond_to do |format|
            if user.present?
                if user.status == "PENDING"
                    if user.password_digest == params[:password]
                        session[:user_id] = user.id
                        session[:user_type] = user.user_type
                        format.html{redirect_to "/new_user/#{user.id}"}
                    else
                        format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea", "<ul><li id = 'errMsg' style = 'color:red;'>INCORRECT PASSWORD!</li></ul>")}
                    end
                else
                    if user.authenticate(params[:password])
                        session[:user_id] = user.id
                        session[:user_type] = user.user_type
                        if user.user_type == "ADMIN"
                            format.html{redirect_to "/evac_centers"}
                        else
                            if user.currently_assigned != nil
                                format.html{redirect_to "/evac_centers/#{user.currently_assigned}"}
                            else
                                format.html{redirect_to "/dashboard"}
                            end
                        end

                    else
                        format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea", "<ul><li id = 'errMsg' style = 'color:red;'>INCORRECT PASSWORD!</li></ul>")}
                    end
                end

            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea", "<ul><li id = 'errMsg' style = 'color:red;'>ACCOUNT NOT FOUND!</li></ul>")}
            end
        end
    end

    def log_relief_form

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
        @request.user_type = "VOLUNTEER"
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


    def new_camp_manager

    end

    def create_campmanager
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
        @request.user_type = params[:request][:user_type]
        @request.status = "PENDING"
        respond_to do |format|
            if @request.valid?
                if params[:request][:valid_id] == nil || params[:request][:selfie] == nil
                    format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea","Both IDs are required.")}
                else
                    @request.save
                    num1 = rand(10..99).to_s
                    num2 = rand(10..99).to_s
                    @user = User.new
                    @user.assigned = false
                    puts params[:request][:user_type]
                    @user.user_type = @request.user_type
                    @user.status = "PENDING"
                    @user.fname = @request.fname
                    @user.lname = @request.lname
                    @user.email = @request.email
                    @user.cnum = @request.cnum
                    @user.bdate = @request.bdate
                    @user.address = @request.address
                    @user.password_digest = "@Vr"+ num1 + num2 + @request.bdate.year.to_s
                    @user.full_name = @request.lname.to_s + ", "+ @request.fname.to_s
                    if @user.valid?
                        @user.save
                        @request.status = "APPROVED"
                        @request.save
                        AccountMailer.with(user: @user).account_confirmation.deliver_now
                        format.html{redirect_to "/camp_managers"}
                    end
                end

            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("request_form",partial:"campmanager_form",locals:{request:@request})}
            end
        end


    end

end
