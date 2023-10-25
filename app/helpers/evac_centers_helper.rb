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

    def countIndivEvacuated(evac_disaster_profile )
        evacuatedIndiv = 0
        if(evac_match_evacuee = Evacuee.find_by(evac_id: evac_disaster_profile) != nil)
            evac_match_evacuee = Evacuee.all.where(evac_id: evac_disaster_profile)
            evac_match_evacuee.each do |mat|
                evac_indiv = FamilyMember.all.where(evacuee_id: mat.id) 
                evac_indiv.each do |fam|
                #  if Evacuee.all.where(evac_id: evac_disaster_profile)
                        evacuatedIndiv=evacuatedIndiv+1
                    #end
                end
            end
        end
        return evacuatedIndiv
    end
    
    def countGenFamily(evac_center)
        countFamily = 0
        evac_evacuee = Evacuee.all.where(evac_id: evac_center) #id
        evac_fam = Family.all.where(is_evacuated: true) #id
        evac_evacuee.each do |evac|
            evac_fam.each do |fam|
                if (FamilyMember.all.where("family_id = ? AND evacuee_id = ? ", fam.id,  evac.id).length > 0)
                    if(evac.evac_id == evac_center)
                        countFamily = countFamily + 1
                    end
                end
            end
        end
        return countFamily
    end

end
