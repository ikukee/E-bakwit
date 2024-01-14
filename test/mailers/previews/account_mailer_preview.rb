# Preview all emails at http://localhost:3000/rails/mailers/account_mailer
class AccountMailerPreview < ActionMailer::Preview
    def account_confirmation
        user = User.new(fname: "James", email:"juntadomathewjames@gmail.com", lname: "Juntado", address:"1 Cadena de amor Street, Queborac Drive, Bagumbayan Sur, Naga City",cnum:"09380261902",bdate:"12-08-2002",password_digest:"1234567891") 
        AccountMailer.with(user: user).account_confirmation
      end
end
