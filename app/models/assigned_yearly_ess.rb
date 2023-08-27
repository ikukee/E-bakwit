class AssignedYearlyEss < ApplicationRecord
    validates :ess_id, :evac_profile_id, :quantity, presence: true
    
end
