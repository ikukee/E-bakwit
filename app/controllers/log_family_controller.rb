class LogFamilyController < ApplicationController
    def search
        #search_type = "name"
        #@members = FamilyMember.all
        #@family = Family.where("#{search_type} LIKE ? ", "#{params[:id]}%").order(:name)
        
        
       # @families = Family.find(params[:id])
        #@families = Family.all
        #puts "SEARCH : #{@members[1].lname}"
        #puts "FAMILY :  #{params[:id]}"
        #puts "FAMILY : #{@families.name}"
       # families = Family.find_by("name LIKE ? ", "#{params[:id]}%")
       # respond_to do |format|
        #    if @family.length  > 0 && @families.present?
        #        @result = Family.find(@families.id).family_members
         #       format.turbo_stream{render turbo_stream: turbo_stream.update("member-list",partial: "family-mem-result", locals:{families:@result})}  
        #    elsif @family.length <=0
        #        format.turbo_stream{render turbo_stream: turbo_stream.update("member-list","<h2>Not Found</h2>")}  
        #    end
        #end
        
        @families = Family.find_by("LOWER(name)= ?", params[:id].downcase)
        respond_to do |format|
               
            if @families.present? && @families.id > 0
                @result = Family.find(@families.id).family_members
                format.turbo_stream{render turbo_stream: turbo_stream.update("member-list",partial: "family-mem-result", locals:{families:@result})}  
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("member-list","<h2>Not Found</h2>")} 
            end
        end
    end
    def logging
        @evac_center = EvacCenter.find(params[:id])
        evacuee = Evacuee.new
    end

    def evacuate ## post
        evac_center = EvacCenter.find(params[:evac_id])  
       
        if(Evacuee.find_by(family_id: params[:family_id]) == nil)
            evacuee = Evacuee.new 
            evacuee.family_id = params[:family_id]
            evacuee.disaster_id = 1
            evacuee.date_in = Time.now
            evacuee.date_out = nil
            evacuee.evac_id = evac_center.id
            
            
            respond_to do |format|
                
                if evacuee.save 
                    arr = params[:mem];
                    if arr != nil
                        for i in 0..arr.length do
                            family_mem = FamilyMember.find(arr[i])
                            family_mem.update_column(:evacuee_id, evacuee.id )
                            puts "=======#{family_mem.lname}"
                        end 
                    else
                        puts 'nil'
                    end 
                    puts 'save' 
                else
                    puts 'error'
                end
            end
        else
            arr = params[:mem];
            existingEvacuee = Evacuee.find_by(family_id: params[:family_id])
            if arr != nil
                for i in 0..arr.length do
                    family_mem = FamilyMember.find(arr[i])
                    family_mem.update_column(:evacuee_id, existingEvacuee.id )
                    puts "=======#{family_mem.lname}"
                end 
            else
                puts 'nil'
            end 
        end

    end

end

