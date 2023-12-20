class MainController < ApplicationController
    before_action :is_logged_in, except: %i[change_pass_proceed change_password forgot_password search_account send_change_password_request login logout register login_proceed register_proceed index send_request_proceed index reqCreate error]
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
        session[:time_out_date] = nil
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
                        session[:time_out_date] = Date.today + 1
                       
                        format.html{redirect_to "/new_user/#{user.id}"}
                    else
                        format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea", "<ul><li id = 'errMsg' style = 'color:red;'>INCORRECT PASSWORD!</li></ul>")}
                    end
                else
                    if user.authenticate(params[:password])
                        session[:user_id] = user.id
                        session[:user_type] = user.user_type
                        session[:time_out_date] = Date.today + 1
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
        add_breadcrumb("New Camp Manager")
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
                        puts "success sent"
                        format.html{redirect_to "/camp_managers"}
                    end
                end

            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("request_form",partial:"campmanager_form",locals:{request:@request})}
            end
        end


    end

    def forgot_password

    end

    def send_change_password_request
        user = User.find(params[:user_id])
        password_session = PasswordSession.new
        password_session.user_id = params[:user_id]
        password_session.exp_date = Time.current.advance(hours: 1)
        password_session.save
        AccountMailer.with(user: user, password_session: password_session).change_password.deliver_now
        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("email_confirmation","An email has been sent to your email address.")}
        end
    end

    def search_account
        users = User.all.where(email: params[:email])
        respond_to do |format|
            if users.length > 0
                user = users.last
                format.turbo_stream{render turbo_stream: turbo_stream.update("account_result",partial:"account_result",locals:{user:user})}
            else
                user = users.last
                format.turbo_stream{render turbo_stream: turbo_stream.update("request_error","No account found under email: <strong>#{params[:email]}</strong>")}
            end
          
        end
       
    end

    def change_password
        @user = User.find(params[:id])
        @password_session = PasswordSession.find(params[:session_id])
        if Time.current > @password_session.exp_date
            redirect_to "/error"
        end
    end

    def change_pass_proceed
        @user = User.find(params[:user_id])
        @password_session = PasswordSession.find(params[:session_id])
        respond_to do |format|
            if params[:password_digest] != nil && params[:confirm_password] !=nil
                if params[:password_digest] ==  params[:confirm_password]
                    @user.password_digest = params[:password_digest]
                    if @user.valid?
                        puts @user.password_digest
                        @user.update_attribute(:password_digest, BCrypt::Password.create(params[:password_digest]))
                        @password_session.update_attribute(:exp_date, Time.current)
                        format.html{redirect_to "/login"}
                    else
                        error_messages = ""
                        @user.errors[:password_digest].each do |err|
                          error_messages = error_messages +  err +"\t\t"
                        end
                        format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea",error_messages)}
                     
                    end
                else
                    format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea","Passwords did not match!")}
                end
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea","Password cannot be blank!")}
            end
        end
    end 

end
