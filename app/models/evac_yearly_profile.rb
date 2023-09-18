class EvacYearlyProfile < ApplicationRecord
    validates :evac_id, presence: true
    validates :year, presence:true, on: :update
end
