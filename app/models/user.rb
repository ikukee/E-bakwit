class User < ApplicationRecord
    has_secure_password
    validates :fname, :lname, :email, :cnum, :user_type, :bdate, :address, presence: true
    validates :cnum, length:{maximum: 11}
    validates :email, uniqueness:true
    validates :password_digest, presence:true,confirmation: true,length: {minimum:8},format: {with: /\A^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$\z/,message:"Password must contain at least 1 lowercase, 1 uppercase, 1 special character, and 1 number"}, on: :create
    validates :password_digest, presence:true,confirmation: true,length: {minimum:8},format: {with: /\A^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$\z/,message:"Password must contain at least 1 lowercase, 1 uppercase, 1 special character, and 1 number"}, on: :update
end