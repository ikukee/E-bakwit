class LogFamilyController < ApplicationController
    def search
        @disaster = Disaster.find(params[:disaster_id])
        @evac_center = EvacCenter.find(params[:evac_center])
        
        @family_member = FamilyMember.find(params[:id])
        @family = Family.find(@family_member.family_id)

        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("member-list",partial: "family-mem-result", locals:{evac_center: @evac_center, families:@family.family_members, disaster:@disaster})}  
        end
    end
    def logging
        @disaster = Disaster.find(params[:disaster_id])
        @evac_center = EvacCenter.find(params[:id])
        evacuee = Evacuee.new
        family = Family.new
    end
# if evacuee not exist
# elseif evacuee exist but not in the same evacuation center and have left
# elseif evacuee exist but not in the same evacuation center and have not left
# elseif evacuee exist on the same evacuation center and have left
    

    # evacuee model id = 2, family_id = 1  <<< RECORD
    # family id = 1,is_evacuated true
    def evacuatedView 
        @evacuee_list = Evacuee.all.where(evac_id: params[:evac_id]).where(disaster_id: params[:disaster_id])
    end

    def view_evacuated_family
        @evacuee = Evacuee.find(params[:evacuee_id])
        @evac_members = EvacMember.all.where(evacuee_id: @evacuee.id)
        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("evacuated-list", partial: "evacuated-result", locals:{evac_members: @evac_members})}
        end
    end

    def evacuate_all
        family = Family.find(params[:family_id])
        disaster = Disaster.find(params[:disaster_id])
        evac_center = EvacCenter.find(params[:evac_id])
        evacuees = Evacuee.all.where(family_id: family.id).where(disaster_id: disaster.id)
        key = false
        evacuee_data = Evacuee.new
        evacuees.each do |evacuee|
            if evacuee.evac_id == evac_center.id
                key =true
                evacuee_data =evacuee
                break
            end
        end

        if !key 
            evacuee_data.family_id = family.id
            evacuee_data.family_name = family.name
            evacuee_data.disaster_id = params[:disaster_id]
            evacuee_data.date_in = Time.now
            evacuee_data.date_out = nil
            evacuee_data.evac_id = params[:evac_id]
            evacuee_data.save
        end

        family_members = FamilyMember.all.where(family_id: family.id)
        family_members.each do |member|
           if member.evacuee_id == nil || member.evacuee_id == 0
            member.update_attribute(:evacuee_id, evacuee_data.id)
            evac_member = EvacMember.new
            evac_member.evacuee_id = evacuee_data.id
            evac_member.member_id = member.id
            evac_member.status = "UNRELEASED"
            evac_member.save
           end
        end
        family.update_attribute(:is_evacuated, true)
        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("member-list",partial: "family-mem-result", locals:{evac_center: evac_center, families:family.family_members, disaster:disaster})}  
        end

      
    end

    def evacuate
        disaster = Disaster.find(params[:disaster_id])
        evac_center = EvacCenter.find(params[:evac_id])     
        family_member = FamilyMember.find(params[:member_id])
        family = Family.find(family_member.family_id)
        evacuees = Evacuee.all.where(family_id: family.id)

        respond_to do |format|
            key = false  
            evacuee_data = Evacuee.new
            evacuees.each do |evacuee| #checks if the existing evacuee record related to the member is on the same evac center
                if evacuee.evac_id == evac_center.id
                    evacuee_data = evacuee
                    key = true
                    break
                end
            end
                
            if !key
                evacuee_data.family_id = family.id
                evacuee_data.family_name = family.name
                evacuee_data.disaster_id = disaster.id
                evacuee_data.date_in = Time.now
                evacuee_data.date_out = nil
                evacuee_data.evac_id = evac_center.id
                evacuee_data.save
            end

            evac_member = EvacMember.new
            evac_member.evacuee_id = evacuee_data.id
            evac_member.member_id = family_member.id
            evac_member.status = "UNRELEASED"
            evac_member.save
            family_member.update_attribute(:evacuee_id, evacuee_data.id)
            format.turbo_stream{render turbo_stream: turbo_stream.update("member-list",partial: "family-mem-result", locals:{evac_center: evac_center, families:family.family_members, disaster:disaster})}  
        end
    end


    def evacueeOut  
        evacuee = FamilyMember.find(params[:member_id])
        evacuee.update_column("evacuee_id", 0)
        member = EvacMember.find_by(member_id: params[:member_id])
        member.destroy
        redirect_to "/evac_center/#{params[:evac_id]}"
    end

    def evacueeReleased  
        family_member = FamilyMember.find(params[:member_id])
        evacuee = Evacuee.find(family_member.evacuee_id)       
        evac_center = EvacCenter.find(evacuee.evac_id)
        evac_member = EvacMember.where(evacuee_id: evacuee.id).where(member_id: family_member.id)
        evac_member.first.update_attribute(:status, "RELEASED")
        family_member.update_attribute(:evacuee_id, 0)

        key = false
        evac_members = EvacMember.all.where(evacuee_id: evacuee.id)
        evac_members.each do |em| #checks if all evacuee members are no longer evacuated
            if em.status == "UNRELEASED"
                key = true
                break
            end
        end
        
        if !key
            evacuee.update_attribute(:date_out, Date.today)
        end

        family_members = FamilyMember.all.where(family_id: family_member.family_id)
        family_members.each do |fm| # checks if all family members are no longer evacuated
            if fm.evacuee_id != 0
                key = true
            end
        end

        if !key
            family = Family.find(family_member.family_id)
            family.update_attribute(:is_evacuated, false)
        end
        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("evacuated-list", partial: "evacuated-result", locals:{evac_members: evac_members})}
        end
        
       
    end


end

