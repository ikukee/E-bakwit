class AccountMailer < ApplicationMailer
    def account_confirmation
        @user = params[:user]
        mail(to: @user.email,subject: "Your request has been approved!")

    end
end
