class AssignedYearlyVol < ApplicationRecord
    
    validates :volunteer_id, :evac_profile_id, presence:true
    
end
