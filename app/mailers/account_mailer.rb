class AccountMailer < ApplicationMailer
    def account_confirmation
        @user = params[:user]
        mail(to: @user.email,subject: "Your request has been approved!")
    end
    def reject_request
        @user = params[:user]
        @message = params[:message]
        mail(to: @user.email ,subject: "Your request has been rejected!")
    end
    def change_password
        @user = params[:user]
        @password_session= params[:password_session]
        mail(to: @user.email ,subject: "Change password request!")
    end
end
