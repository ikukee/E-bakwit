module LogFamilyHelper

    def checkIfAllEvacuated(family_members)
        key = true
        family_members.each do |member|
            if member.evacuee_id == nil || member.evacuee_id == 0
                key = false
                break
            end
        end
        return key 
    end
end
