module ReliefAllocationHelper

    def getQuantity(gen_alloc, members)
        quantity = 0
        criterium = RgCriterium.find_by(gen_rg_alloc_id: gen_alloc.id)
        rg = ReliefGood.find(gen_alloc.rg_id)

        if rg.eligibility == "MALE"
            quantity = criterium.criteria * getTotalCategoryMembers(members, rg.category, "Male")#gets total number of males in a specific category and above
        elsif rg.eligibility == "FEMALE"
            quantity = criterium.criteria * getTotalCategoryMembers(members, rg.category, "Female")#gets total number of females in a specific category and above
        elsif rg.eligibility == "GENERAL USE"
            quantity = criterium.criteria * getTotalCategoryMembers(members, rg.category, nil)#gets total number of members in a specific category and above
        end
        return quantity
    end

    def checkIfRgValid(gen_alloc,members)
        rg = ReliefGood.find(gen_alloc.rg_id)
        if rg.eligibility == "MALE"
            if getTotalSexValMembers(members,"Male") > 0
                if checkIfCategoryExist(members,rg.category,"Male")
                    return true
                else
                    return false
                end
            else
                return false
            end
        elsif rg.eligibility == "FEMALE"
            if getTotalSexValMembers(members,"Female") > 0
                if checkIfCategoryExist(members,rg.category,"Male")
                    return true
                else
                    return false
                end
            else
                return false
            end
        elsif rg.eligibility == "GENERAL USE"
            if checkIfCategoryExist(members,rg.category,nil)
                return true
            else
                return false
            end
        end

        return true
    end

    def checkIfCategoryExist(members,category, sexVal)
        total = 0
        fam_mem = FamilyMember.find(members.first.member_id)
        if sexVal == nil
            fam_members = FamilyMember.all.where(family_id: fam_mem.family_id).where(evacuee_id: fam_mem.evacuee_id)
        else
            fam_members = FamilyMember.all.where(family_id: fam_mem.family_id).where(evacuee_id: fam_mem.evacuee_id).where(sex: sexVal)
        end

        if category == "INFANTS"
            if fam_members.where("age < 0").count > 0
                return true
            end
        elsif category == "TODDLERS"
            if fam_members.where("age > 1 AND age <= 3").count > 0
                return true
            end
        elsif category == "PRE-SCHOOLERS"
            if fam_members.where("age > 3").count > 0
                return true
            end
        elsif category == "SCHOOLAGERS"
            if fam_members.where("age > 5").count > 0
                return true
            end
        elsif category == "TEENAGERS"
            if fam_members.where("age > 12").count > 0
                return true
            end
        elsif category == "ADULTS"
            if fam_members.where("age > 17").count > 0
                return true
            end
        elsif category == "SENIOR CITIZENS"
            if fam_members.where("age >= 60").count > 0
                return true
            end
        elsif category == "ALL"
            return true
        end
    end

    def getTotalSexValMembers(members, sexVal)
        fam_mem = FamilyMember.find(members.first.member_id)
        fam_members = FamilyMember.all.where(family_id: fam_mem.family_id).where(evacuee_id: fam_mem.evacuee_id).where(sex: sexVal).count
        return fam_members
    end

    def getTotalCategoryMembers(members,category,sexVal)
        total = 0
        fam_mem = FamilyMember.find(members.first.member_id)
        if sexVal == nil
            fam_members = FamilyMember.all.where(family_id: fam_mem.family_id).where(evacuee_id:fam_mem.evacuee_id)
        else
            fam_members = FamilyMember.all.where(family_id: fam_mem.family_id).where(evacuee_id:fam_mem.evacuee_id).where(sex: sexVal)
        end

        infant  = fam_members.where("age < 1").count
        toddlers = fam_members.where("age > 1 AND age <=3").count
        pre_schoolers= fam_members.where("age > 3 AND age <=5").count
        schoolagers = fam_members.where("age > 5 AND age <=12").count
        teenagers = fam_members.where("age > 12 AND age <=17").count
        adults = fam_members.where("age > 17 AND age < 60").count
        senior_citizens = fam_members.where("age >= 60").count
        total = fam_members.count
        if category == "INFANT"
            total = infant
        elsif category == "TODDLERS"
            total = infant + toddlers
        elsif category == "PRE-SCHOOLERS"
            total = total - toddlers - infant
        elsif category == "SCHOOLAGERS"
            total =  total - pre_schoolers-toddlers-infant
        elsif category == "TEENAGERS"
            total = total - schoolagers-pre_schoolers-toddlers-infant
        elsif category =="ADULTS"
            total = total - teenagers- schoolagers-pre_schoolers-toddlers-infant
        elsif category == "SENIOR CITIZENS"
            total = senior_citizens
        end

        return total
    end
end
