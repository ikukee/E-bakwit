class EvacCenter < ApplicationRecord
    has_one_attached :image
    validates :name , :barangay, :capacity, presence: true
    validates :name, uniqueness:true, on: :create
    validates :capacity, numericality: {greater_than:0}

end
