require "test_helper"

class AccountMailerTest < ActionMailer::TestCase
    test "account_confirmation" do
        user = users(:one)

        email = AccountMailer.with(user:user).account_confirmation

        assert_emails 1 do 
            email.deliver_now
        end
    end
end

