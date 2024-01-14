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
            evacuatedIndiv = getMembers(evacuees).length
        end

        return evacuatedIndiv
    end

    def countGenFamily(evac_center, disaster, key )

        countFam = 0
        if key
            #evacuee = Evacuee.find_by_sql("Select * FROM evacuees where evac_id = '#{evac_center}' AND disaster_id = '#{disaster.id}' AND date_out = #{nil} GROUP BY family_id")
           evacuee = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster.id).where(date_out: nil).group(:family_id).count
        else
            #evacuee = Evacuee.find_by_sql("Select * FROM evacuees where evac_id = '#{evac_center}' AND disaster_id = '#{disaster.id}' GROUP BY family_id")
            evacuee = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster.id).group(:family_id).count
        end

        return evacuee.length
    end

    def countGenderEvacuated(evac_center,disaster, sexVal)
        evacuatedIndiv = 0
        evacuees = Evacuee.all.where(disaster_id: disaster.id).where(evac_id: evac_center)
        if evacuees.length > 0
            getMembers(evacuees).each do |mem|
                fam_mem = FamilyMember.find(mem)
                if fam_mem.sex == sexVal
                    evacuatedIndiv = evacuatedIndiv +1
                end
            end
        end
        return evacuatedIndiv
    end

    def countGenderCurrentlyEvacuated(evac_center,disaster, sexVal)
        count = 0
        EvacMember.all.where(evacuee_id: Evacuee.all.where(disaster_id: disaster).where(evac_id: evac_center)).where(status: "UNRELEASED").each do |ur|
            if FamilyMember.find_by(id: ur.member_id).sex == sexVal
                count = count + 1
            end
        end
        return count
    end

    def countIndivCurrentlyEvacuated(evac_center,disaster)
        currently_evacuated = EvacMember.all.where(evacuee_id: Evacuee.all.where(disaster_id: disaster).where(evac_id: evac_center)).where(status: "UNRELEASED")
        if currently_evacuated == nil
            return 0
        end
        return currently_evacuated.length
    end

    def countIndivCurrentlyEvacuatedCard(evac_center)
        return EvacMember.all.where(status: "UNRELEASED").where(evacuee_id: Evacuee.all.where(evac_id: evac_center)).length
    end

    def countFamCurrentlyEvacuatedCard(evac_center)
        return Evacuee.all.where(evac_id: evac_center).where(date_out: nil).length
    end

    def getInfants(evac_center,disaster, sexVal)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        getMembers(evacuees).each do |mem|
            fam_mem = FamilyMember.find(mem)
            if fam_mem.sex == sexVal && fam_mem.age < 1
                total = total + 1
            end
        end
        return total
    end

    def getToddlers(evac_center,disaster,sexVal)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        getMembers(evacuees).each do |mem|
            fam_mem = FamilyMember.find(mem)
            if fam_mem.sex == sexVal && fam_mem.age > 1 && fam_mem.age <=3
                total = total + 1
            end
        end
        return total
    end

    def getPreschoolers(evac_center,disaster,sexVal)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        getMembers(evacuees).each do |mem|
            fam_mem = FamilyMember.find(mem)
            if fam_mem.sex == sexVal && fam_mem.age > 3 && fam_mem.age <=5
                total = total + 1
            end
        end
        return total
    end

    def getSchoolagers(evac_center,disaster,sexVal)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        getMembers(evacuees).each do |mem|
            fam_mem = FamilyMember.find(mem)
            if fam_mem.sex == sexVal && fam_mem.age > 5 && fam_mem.age <=12
                total = total + 1
            end
        end
        return total
    end

    def getTeenagers(evac_center,disaster,sexVal)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        getMembers(evacuees).each do |mem|
            fam_mem = FamilyMember.find(mem)
            if fam_mem.sex == sexVal && fam_mem.age > 12 && fam_mem.age <=17
                total = total + 1
            end
        end
        return total
    end

    def getAdults(evac_center,disaster,sexVal)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        getMembers(evacuees).each do |mem|
            fam_mem = FamilyMember.find(mem)
            if fam_mem.sex == sexVal && fam_mem.age > 17 && fam_mem.age < 60
                total = total + 1
            end
        end
        return total
    end

    def getSeniors(evac_center,disaster,sexVal)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        getMembers(evacuees).each do |mem|
            fam_mem = FamilyMember.find(mem)
            if fam_mem.sex == sexVal && fam_mem.age >= 60
                total = total + 1
            end
        end
        return total
    end

    def getCapacityPercentage(evacuees, capacity)
        return (evacuees.to_f/capacity.to_f) * 100
    end

    def getRg(evac_center,disaster,key)#if key is true choose food else non food
        food = 0
        non_food =0
        gen_rg_allocs = GenRgAlloc.all.where(evac_id: evac_center).where(disaster_id: disaster)
        gen_rg_allocs.each do |gen|
            rg = ReliefGood.find(gen.rg_id)
            if rg.is_food == true
                food = food+1
            else
                non_food = non_food +1
            end
        end
        if key
            return food
        else
            return non_food
        end
    end

    private

    def getMembers(evacuees)
        member_ids = Array.new
        evacuees.each do |ec|
            EvacMember.all.where(evacuee_id: ec.id).each do |em|
                if !member_ids.include?(em.member_id)
                    member_ids.push(em.member_id)
                end
            end
        end
        return member_ids
    end
end
