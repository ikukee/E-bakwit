class EvacCenter < ApplicationRecord
    has_one_attached :image
    validates :name , :barangay, presence: true
    validates :name, uniqueness:true

end
