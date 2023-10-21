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
    end
end

