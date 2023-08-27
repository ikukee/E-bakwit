class EvacCenter < ApplicationRecord
    validates :name, :isInside , :barangay, presence: true
    validates :name, uniqueness:true

end
