module GenerateReportHelper
    def countServedFamilyType(value )
        if value > 0
            return 1
        else
            return 0
        end 
    end

    def gcountGenderEvacuated(evac_center,disaster, sexVal, k)
        evacuatedIndiv = 0
        evacuees = Evacuee.all.where(disaster_id: disaster.id).where(evac_id: evac_center)
        if evacuees.length > 0
            ggetMembers(evacuees, k).each do |mem|
                fam_mem = FamilyMember.find(mem)
                if fam_mem.sex == sexVal
                    evacuatedIndiv = evacuatedIndiv +1
                end
            end
        end
        return evacuatedIndiv
    end

    def ggetInfants(evac_center,disaster, sexVal, k)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        ggetMembers(evacuees, k).each do |mem|
            fam_mem = FamilyMember.find(mem)
            if fam_mem.sex == sexVal && fam_mem.age < 1
                total = total + 1
            end
        end
        return total
    end

    def ggetToddlers(evac_center,disaster,sexVal, k)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        ggetMembers(evacuees, k).each do |mem|
            fam_mem = FamilyMember.find(mem)
            if fam_mem.sex == sexVal && fam_mem.age > 1 && fam_mem.age <=3
                total = total + 1
            end
        end
        return total
    end

    def ggetPreschoolers(evac_center,disaster,sexVal, k)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        ggetMembers(evacuees, k).each do |mem|
            fam_mem = FamilyMember.find(mem)
            if fam_mem.sex == sexVal && fam_mem.age > 3 && fam_mem.age <=5
                total = total + 1
            end
        end
        return total
    end

    def ggetSchoolagers(evac_center,disaster,sexVal, k)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        ggetMembers(evacuees, k).each do |mem|
            fam_mem = FamilyMember.find(mem)
            if fam_mem.sex == sexVal && fam_mem.age > 5 && fam_mem.age <=12
                total = total + 1
            end
        end
        return total
    end

    def ggetTeenagers(evac_center,disaster,sexVal, k)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        ggetMembers(evacuees, k).each do |mem|
            fam_mem = FamilyMember.find(mem)
            if fam_mem.sex == sexVal && fam_mem.age > 12 && fam_mem.age <=17
                total = total + 1
            end
        end
        return total
    end

    def ggetAdults(evac_center,disaster,sexVal, k)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        ggetMembers(evacuees, k).each do |mem|
            fam_mem = FamilyMember.find(mem)
            if fam_mem.sex == sexVal && fam_mem.age > 17 && fam_mem.age < 60
                total = total + 1
            end
        end
        return total
    end

    def ggetSeniors(evac_center,disaster,sexVal, k)
        total = 0
        evacuees = Evacuee.all.where(evac_id: evac_center).where(disaster_id: disaster)
        ggetMembers(evacuees, k).each do |mem|
            fam_mem = FamilyMember.find(mem)
            if fam_mem.sex == sexVal && fam_mem.age >= 60
                total = total + 1
            end
        end
        return total
    end
    def zcountServedFamily(evac_center, disaster, key )
        
        countFam = 0

        if key 
            evacuee = Evacuee.find_by_sql("SELECT DISTINCT(family_id) from evacuee where evac_id = #{evac_center} AND disaster_id = #{disaster} AND date_out = #{nil}")
            
        else
            evacuee = Evacuee.find_by_sql("SELECT DISTINCT(family_id) from evacuee where evac_id = #{evac_center} AND disaster_id = #{disaster}")
        end
        
        evacuee.each do |x| 
            countFam = countFam + 1
        end   
        return countFam
    end
    def zcountIndivEvacuated(evac_center,disaster,key)
        evacuees = Evacuee.all.where(disaster_id: disaster).where(evac_id: evac_center)
        if key 
            member_ids = Array.new
            evacuees.each do |ec|
                EvacMember.all.where(evacuee_id: ec.id).where(status: "UNRELEASED").each do |em|
                       if !member_ids.include?(em.member_id)
                        member_ids.push(em.member_id)
                    end
                end
            end
            return member_ids.length
        else
            member_ids = Array.new
            evacuees.each do |ec|
                EvacMember.all.where(evacuee_id: ec.id).each do |em|
                       if !member_ids.include?(em.member_id)
                        member_ids.push(em.member_id)
                    end
                end
            end
            return member_ids.length
        end
    end
    private 

    def ggetMembers(evacuees, k)
        member_ids = Array.new
        evacuees.each do |ec|
            if !k
                EvacMember.all.where(evacuee_id: ec.id).each do |em|
                    if !member_ids.include?(em.member_id)
                        member_ids.push(em.member_id)
                    end
                end
            else
                EvacMember.all.where(evacuee_id: ec.id).where(status: "UNRELEASED").each do |em|
                    if !member_ids.include?(em.member_id)
                        member_ids.push(em.member_id)
                    end
                end
            end

        end
        return member_ids
    end
    
end
