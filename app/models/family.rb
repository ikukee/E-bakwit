class Family < ApplicationRecord
    validates :name, :streetName, :barangay, presence:true
    validates :zone, :houseNum, numericality:{greater_than: 0}
end
