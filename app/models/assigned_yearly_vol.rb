class AssignedYearlyVol < ApplicationRecord
    
    validates :volunteer_id, :evac_profile_id, presence:true
    validate :checkExistingUser

    def checkExistingUser
        evac_profiles = EvacYearlyProfile.all.where(year: EvacYearlyProfile.find(evac_profile_id).year)
        evac_profiles.each do |ep|
            avs = AssignedYearlyVol.all.where(evac_profile_id: ep.id)
            avs.each do |av|
                if av.volunteer_id == volunteer_id
                    errors.add(:volunteer_id, "Volunteer has already been assigned.")
                end
            end
        end
        
    end
end
