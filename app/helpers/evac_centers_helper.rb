module EvacCentersHelper

    def countFacilities(evac_yearly_profile)
        facilities =0
        assigned_yearly_esses = AssignedYearlyEss.all.where(evac_profile_id: evac_yearly_profile.id)
        assigned_yearly_esses.each do |ae|
            if EvacuationEssential.find(ae.ess_id).ess_type == "FACILITY"
                facilities = facilities+1
            end
        end
        return facilities
    end
    def countItems(evac_yearly_profile)
        items =0
        assigned_yearly_esses = AssignedYearlyEss.all.where(evac_profile_id: evac_yearly_profile.id)
        assigned_yearly_esses.each do |ae|
            if EvacuationEssential.find(ae.ess_id).ess_type == "ESSENTIAL"
                items = items+1
            end
        end
        return items
    end
    def countEvacuated(evac_disaster_profile)
        evacuated = 0
        evac_families = Family.all.where(is_evacuated: true)
        evac_families.each do |fam|
            if(FamilyMember.all.where("family_id = ? AND evacuee_id > ? ", fam.id,  0).length > 0) 
                if(Evacuee.find_by(family_id: fam.id) != nil)
                    evacuated = evacuated +1
                end
            end 
        end
        return evacuated
    end
    # match evacuee.evacuee_id = family_member.evacuee_id
    # match evacuee.evac_id = evac_id 

    def countIndivEvacuated(evac_center,disaster)
        evacuatedIndiv = 0
        evacuees = Evacuee.all.where(disaster_id: disaster.id).where(evac_id: evac_center)
        if evacuees.length > 0
            evacuees.each do |evacuee|
                evacuee_members = EvacMember.all.where(evacuee_id: evacuee.id)
                evacuatedIndiv = evacuatedIndiv + evacuee_members.length
            end
        end
        
        return evacuatedIndiv
    end
    
    def countGenFamily(evac_center, disaster)
        
        countFam = 0
        evacuee = Evacuee.all.where("evac_id = ?", evac_center).where(disaster_id: disaster.id)
        evacuee.each do |x| 
            if x.date_out.blank? 
                countFam = countFam + 1
            end
        end   
        return countFam
    end

    def countGenderEvacuated(evac_center,disaster, sexVal)
        evacuatedIndiv = 0
        evacuees = Evacuee.all.where(disaster_id: disaster.id).where(evac_id: evac_center)
        if evacuees.length > 0
            evacuees.each do |evacuee|
                evacuee_members = EvacMember.all.where(evacuee_id: evacuee.id)
                evacuee_members.each do |em|
                    fam_mem = FamilyMember.find(em.member_id)
                    if fam_mem.sex == sexVal
                        evacuatedIndiv = evacuatedIndiv +1
                    end
                end
            end
        end
        return evacuatedIndiv
    end
end
