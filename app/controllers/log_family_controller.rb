class LogFamilyController < ApplicationController
    def search
        #search_type = "id"
        #@members = FamilyMember.all
        @families = Family.find(params[:id]).family_members
        #@families = Family.all
        #puts "SEARCH : #{@members[1].lname}"
        #puts "FAMILY :  #{params[:id]}"
        #puts "FAMILY : #{@families.name}"

        respond_to do |format|
        format.turbo_stream{render turbo_stream: turbo_stream.update("member-list",partial: "family-mem-result", locals:{families:@families })}  
        end
    end
    def logging
        

    end
end

