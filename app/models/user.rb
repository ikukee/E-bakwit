class User < ApplicationRecord
    has_secure_password
    validates :fname, :lname, :email, :cnum, :password_digest, :user_type, :bdate, :address, presence: true
    validates :cnum, length:{maximum: 11}
    validates :email, uniqueness:true
    validates :password_digest, length:{minimum: 8}
    validates :password_digest, presence: true, on: :update
end
