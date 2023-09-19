class AssignedYearlyEss < ApplicationRecord
    validates :ess_id, :evac_profile_id, :quantity, :status, presence: true
    validates :quantity, numericality:{greater_than: 0}
    validate :checkEssentialDuplicate
    def checkEssentialDuplicate
        assigned_yearly_ess = AssignedYearlyEss.all.where(evac_profile_id: evac_profile_id)
        assigned_yearly_ess.each do |ae|
            if ae.ess_id == ess_id
                errors.add(:ess_id , "Item has already been added")
            end
        end
    end
end
