class User < ApplicationRecord
    has_secure_password
    
    validates :fname, :lname, :email, :cnum, :password_digest, :user_type, presence: true
    validates :cnum, length:{maximum: 11}
    validates :email, uniqueness:true
    validates :password_digest, length:{minimum: 8}

    validate :password_check

    def password_check
        special = "?<>',?[]}{=-)(*&^%$#`~{}"
        regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
        pass = password_digest
        if !(pass =~ /[A-Z]/ && pass =~ /[a-z]/ && pass =~ regex && pass =~ /\d/ )
            errors.add(:password_digest, "Password must contain at least 1 uppercase, 1 lowercase, 1 special character, and 1 number")
        end

    end
end
