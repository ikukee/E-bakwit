class Request < ApplicationRecord
    has_many_attached :images
    validates :fname, :lname, :bdate, :email, :address, :cnum, presence: true
    validates :email, uniqueness:true
    validates :cnum, length: {minimum:11,maximum:11}

 
  
end
