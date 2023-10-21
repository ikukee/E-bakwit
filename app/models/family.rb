class Family < ApplicationRecord
    validates :name, :streetName, :barangay, presence:true
    validates :zone, :houseNum, numericality:{greater_than: 0}
    has_many :family_members
    has_one :evacuee
end
