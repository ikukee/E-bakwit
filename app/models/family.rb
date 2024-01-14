class Family < ApplicationRecord
    validates :name, :streetName, :barangay, presence:true
    has_many :family_members
    has_one :evacuee
end
