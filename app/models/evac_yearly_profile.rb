class EvacYearlyProfile < ApplicationRecord
    validates :evac_id, presence: true
    validates :year, presence:true, on: :update
    validate :checkExistingCampManager
    def checkExistingCampManager
        evac_yearly_profiles = EvacYearlyProfile.all.where(year: year)
        if manager_id != nil
            evac_yearly_profiles.each do |ep|
                if ep.manager_id == manager_id
                    errors.add(:manager_id, "Manager has already been assigned.")
                end
            end
        end
    end

end
