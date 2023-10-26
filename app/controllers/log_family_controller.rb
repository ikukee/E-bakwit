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
                format.turbo_stream{render turbo_stream: turbo_stream.update("member-list",partial: "create-fam-btn" )} 
            end
        end
    end
    def logging
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
        @evacuee_list = Evacuee.all.where(evac_id: params[:evac_id])
        
    end
    def evacuate

        evac_center = EvacCenter.find(params[:evac_id])      
        #family_id << PARAMS
        evacuees = Evacuee.all.where(family_id: params[:family_id])
        key = false
            evacuees.each do |evacuee|
                if(evacuee.evac_id == params[:evac_id].to_i)
                    key = true
                    break
                end
            end
        puts key 
        if(evacuees.length() < 1 || !key)
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
                        for i in 0..arr.length-1 do
                           
                            family_mem = FamilyMember.find(arr[i])
                            family_mem.update_column(:evacuee_id, evacuee.id )
                        end
                        
                        myFam = Family.find(params[:family_id])
                        if(myFam.is_evacuated != true )
                            
                            myFam.update_attribute(:is_evacuated, true)
                        end
                        flash[:notice] = "SUCCESSFULLY LOGGED!"
                        redirect_to "/evac_centers/#{params[:evac_id]}/log", notice: "SUCCESS!"
                    else
                        puts 'nil'
                    end 
                    puts 'save' 
                else
                    puts 'error'
                end
            end
        else
            if(key)
                evacuee = Evacuee.find_by(evac_id: params[:evac_id])
                # same evac
                if(evacuee.date_out == nil)
                    # family left
                    # update
                    arr = params[:mem];
                   
                    if arr != nil
                        for i in 0..arr.length-1 do
            
                            family_mem = FamilyMember.find(arr[i])
                            family_mem.update_column(:evacuee_id, evacuee.id )

                        end 
                        
                        myFam = Family.find(params[:family_id])
                        if(myFam.is_evacuated != true )
                        
                            myFam.update_attribute(:is_evacuated, true)
                        end
                        flash[:notice] = "SUCCESSFULLY LOGGED!"
                        redirect_to "/evac_centers/#{params[:evac_id]}/log"

                    else
                        puts 'nil'
                    end 
                elsif(evacuee.date_out != nil)
                    # family here
                    # new
                    evacuee = Evacuee.new
                    evacuee.family_id = params[:family_id]
                    evacuee.disaster_id = 1
                    evacuee.date_in = Time.now
                    evacuee.date_out = nil
                    evacuee.evac_id = evac_center.id
                    
                    puts 'if 1'
                    respond_to do |format|
                        
                        if evacuee.save 
                            arr = params[:mem];
                            if arr != nil
                                for i in 0..arr.length-1 do
                                
                                    family_mem = FamilyMember.find(arr[i])
                                    family_mem.update_column(:evacuee_id, evacuee.id )
                                end
                                
                                myFam = Family.find(params[:family_id])
                                if(myFam.is_evacuated != true )
                                    
                                    myFam.update_attribute(:is_evacuated, true)
                                end
                                flash[:notice] = "SUCCESSFULLY LOGGED!"
                                redirect_to "/evac_centers/#{params[:evac_id]}/log", notice: "SUCCESS!"
                            else
                                puts 'nil'
                            end 
                            puts 'save' 
                        else
                            puts 'error'
                        end
                    end
                end
            end
        end
    end


    def evacueeOut  
        evacuee = FamilyMember.find(params[:evacuee_id])
        family = Family.find(evacuee.family_id)       
        evacModel = Evacuee.find(evacuee.evacuee_id)
        evac_center = EvacCenter.find(evacModel.evac_id)
        evacuee.update_column("evacuee_id", 0)
        if(FamilyMember.all.where("family_id = ? AND evacuee_id = ?", family.id,  evacModel).length == 0)
            family.update_attribute(:is_evacuated, false)
            evacModel.update_attribute(:date_out, Time.now)
        end
        redirect_to "/evac_center/#{params[:evac_id]}"
    end

end

