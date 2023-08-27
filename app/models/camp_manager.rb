class CampManager < ApplicationRecord
    validates :fname, :lname, :cnum, :status, presence:true
    validates :cnum, uniqueness:true, length: {maximum: 11}
end
