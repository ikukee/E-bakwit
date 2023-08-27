class EvacYearlyProfile < ApplicationRecord

    validates :evac_id, :manager_id, :year, presence: true
    validates :year, uniqueness: true
    
end
