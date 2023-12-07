class VolunteerController < ApplicationController
    before_action :is_logged_in
    before_action :checkValidUser, except: %i[change_password]
    def camp_managers
        add_breadcrumb('Camp Managers')
        @users = User.all.where(user_type: "CAMP MANAGER")
        @page = params.fetch(:page, 0).to_i
        if  @page < 0
            @page = 0
        end
        @users_count = @users.length
        @users_count_per_page = 10
        @users = User.offset(@page * @users_count_per_page).limit(@users_count_per_page).where(user_type: "CAMP MANAGER")
    end

    def index
        add_breadcrumb('Volunteers')
        @users = User.all.where(user_type: "VOLUNTEER")
        @page = params.fetch(:page, 0).to_i
        if  @page < 0
            @page = 0
        end
        @users_count = @users.length
        @users_count_per_page = 10
        @users = User.offset(@page * @users_count_per_page).limit(@users_count_per_page).where(user_type: "VOLUNTEER")
    end

    def admins
        add_breadcrumb('Administrators')
        @users = User.all.where(user_type: "ADMIN")
        @page = params.fetch(:page, 0).to_i
        if  @page < 0
            @page = 0
        end
        @users_count = @users.length
        @users_count_per_page = 10
        @users = User.offset(@page * @users_count_per_page).limit(@users_count_per_page).where(user_type: "ADMIN")
    end

    def search
        user_type = params[:user_type].to_s
        search_type = params[:search_type].to_s
        if params[:search_type] == "LAST NAME"
            search_type = "lname"
        elsif params[:search_type] == "IS ASSIGNED"
            search_type = "assigned"
        else
            search_type = "status"
        end
        @users = User.where("#{search_type} LIKE ? ", "#{params[:search_value]}%").where(user_type: user_type).order(lname: :asc)
        respond_to do |format|
          if @users.length > 0
              format.turbo_stream{render turbo_stream: turbo_stream.update("users",partial: "search_results", locals:{users:@users })}
          elsif @users.length <= 0
            @users = User.where(user_type: user_type).order(lname: :asc)
            format.turbo_stream{render turbo_stream: turbo_stream.update("users",partial: "search_results", locals:{users:@users })}
          end
        end

    end

    def volunteer_requests
        add_breadcrumb('Volunteer Requests')
        @requests = Request.all
        @page = params.fetch(:page, 0).to_i
        if  @page < 0
            @page = 0
        end
        @requests_count = @requests.length
        @requests_count_per_page = 10
        @requests = Request.offset(@page * @requests_count_per_page).limit(@requests_count_per_page)
    end

    def first_login
        @user = User.find(params[:id])
    end


    def display_request
        request = Request.find(params[:id])
        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("view_request", partial:"view_request",locals:{request: request})}
        end
    end

    def display_volunteer
        user = User.find(params[:id])
        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("view_volunteer", partial:"view_volunteer",locals:{user: user})}
        end
    end

    def approve_request
        num1 = rand(10..99).to_s
        num2 = rand(10..99).to_s
        request = Request.find(params[:id])

        @user = User.new
        @user.assigned = false
        @user.user_type =  request.user_type
        @user.status = "PENDING"
        @user.fname = request.fname
        @user.lname = request.lname
        @user.email = request.email
        @user.cnum = request.cnum
        @user.bdate = request.bdate
        @user.address = request.address
        @user.password_digest = "@Vr"+ num1 + num2 + request.bdate.year.to_s

        @user.full_name = request.lname.to_s + ", "+ request.fname.to_s
        if @user.valid?
            @user.save
            request.status = "APPROVED"
            request.save
            AccountMailer.with(user: @user).account_confirmation.deliver_now!
            puts "success sent"
            redirect_to "/requests"
        end
    end

    def reject_request
        request = Request.find(params[:id])
        message = params[:message]
        request.update_attribute(:status, "REJECTED")
        AccountMailer.with(user:request,message: message).reject_request.deliver_now!
        puts "success reject"
        redirect_to "/requests"
    end

    def change_password
        user = User.find(params[:user_id])
        puts params[:password_digest]
        puts params[:confirm_password]

        respond_to do |format|
            if user.valid?
                if user.status == "ACTIVE"
                    if user.authenticate(params[:password])
                        if params[:password_digest] == params[:confirm_password]
                            user.password_digest = params[:password_digest]
                            user.update_attribute(:password_digest, BCrypt::Password.create(params[:password_digest]) )
                            format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea", "<ul><li id = 'errMsg' style = 'color:green;'>Password Successfully Changed</li></ul>")}
                        else
                            format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea", "<ul><li id = 'errMsg' style = 'color:red;'>Password did not match!</li></ul>")}
                        end
                    else
                        format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea", "<ul><li id = 'errMsg' style = 'color:red;'>Incorrect Old Password!</li></ul>")}
                    end
                else
                    if params[:password_digest] == params[:confirm_password]
                        user.password_digest = params[:password_digest]
                        user.update_attribute(:password_digest, BCrypt::Password.create(params[:password_digest]) )
                        user.update_attribute(:status, "ACTIVE")
                        format.html{redirect_to "/dashboard"}
                    else
                        format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea", "<ul><li id = 'errMsg' style = 'color:red;'>Password did not match!</li></ul>")}
                    end
                end

            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea", "<ul><li id = 'errMsg' style = 'color:red;'>Password cannot be blank!</li></ul>")}
            end
        end
    end

    def download
        request = Request.find(params[:id])
        img = request.images.find_by(blob_id: params[:img_id])
        extension = img.filename.to_s.split(".")
        send_data img.download, filename: "Attachment #{params[:counter]}.#{extension[1]}", type: img.content_type
    end

end
