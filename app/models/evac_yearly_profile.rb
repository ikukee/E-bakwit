class EvacYearlyProfile < ApplicationRecord
    validates :evac_id, presence: true
    validates :manager_id, :year, presence:true, on: :update
    
end
