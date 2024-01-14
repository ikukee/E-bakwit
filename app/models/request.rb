class Request < ApplicationRecord
    has_many_attached :images, dependent: :destroy
    validates :fname, :lname, :bdate, :email, :address, :cnum, :request_date, :user_type, presence: true
    validates :email, uniqueness:true
    validates :cnum, length: {minimum:11,maximum:11}



end
