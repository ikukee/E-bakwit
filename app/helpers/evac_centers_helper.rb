module EvacCentersHelper

    def countFacilities(evac_yearly_profile)
        facilities =0
        assigned_yearly_esses = AssignedYearlyEss.all.where(evac_profile_id: evac_yearly_profile.id)
        assigned_yearly_esses.each do |ae|
            if EvacuationEssential.find_by(id: ae.ess_id)
                if EvacuationEssential.find(ae.ess_id).ess_type == "FACILITY"
                    facilities = facilities+ 1
                end
            end
        end
        return facilities
    end
    def countItems(evac_yearly_profile)
        items =0
        assigned_yearly_esses = AssignedYearlyEss.all.where(evac_profile_id: evac_yearly_profile.id)
        assigned_yearly_esses.each do |ae|
            if EvacuationEssential.find_by(id: ae.ess_id)
                if EvacuationEssential.find(ae.ess_id).ess_type == "ESSENTIAL"
                    items = items+1
                end
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
    
    def countGenFamily(evac_center, disaster, key)
        countFam = 0
        evacuee = Evacuee.all.where("evac_id = ?", evac_center).where(disaster_id: disaster.id)
        if key
            evacuee.each do |x| 
                if x.date_out.blank? 
                    countFam = countFam + 1
                end
            end  
        else
            countFam = evacuee.length
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

    def getInfants(evac_center,disaster, sexVal)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        evacuees.each do |ec|
            family = Family.find(ec.family_id)
            family_members = FamilyMember.all.where(family_id: family.id).where("age <= 1").where(sex: sexVal)
            total = total + family_members.length
        end
        return total
    end

    def getToddlers(evac_center,disaster,sexVal)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        evacuees.each do |ec|
            family = Family.find(ec.family_id)
            family_members = FamilyMember.all.where(family_id: family.id).where("age > 1 AND age <= 3").where(sex: sexVal)
            total = total + family_members.length
        end
        return total
    end

    def getPreschoolers(evac_center,disaster,sexVal)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        evacuees.each do |ec|
            family = Family.find(ec.family_id)
            family_members = FamilyMember.all.where(family_id: family.id).where("age > 3 AND age <= 5").where(sex: sexVal)
            total = total + family_members.length
        end
        return total
    end

    def getSchoolagers(evac_center,disaster,sexVal)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        evacuees.each do |ec|
            family = Family.find(ec.family_id)
            family_members = FamilyMember.all.where(family_id: family.id).where("age > 6 AND age <= 12").where(sex: sexVal)
            total = total + family_members.length
        end
        return total
    end

    def getTeenagers(evac_center,disaster,sexVal)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        evacuees.each do |ec|
            family = Family.find(ec.family_id)
            family_members = FamilyMember.all.where(family_id: family.id).where("age > 12 AND age <= 17").where(sex: sexVal)
            total = total + family_members.length
        end
        return total
    end

    def getAdults(evac_center,disaster,sexVal)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        evacuees.each do |ec|
            family = Family.find(ec.family_id)
            family_members = FamilyMember.all.where(family_id: family.id).where("age > 17 AND age <= 60").where(sex: sexVal)
            total = total + family_members.length
        end
        return total
    end

    def getSeniors(evac_center,disaster,sexVal)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        evacuees.each do |ec|
            family = Family.find(ec.family_id)
            family_members = FamilyMember.all.where(family_id: family.id).where("age >= 60").where(sex: sexVal)
            total = total + family_members.length
        end
        return total
    end

    def getCapacityPercentage(evacuees, capacity)
        return (evacuees.to_f/capacity.to_f) * 100
    end




end
