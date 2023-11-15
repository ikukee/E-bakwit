class GenerateReportController < ApplicationController
    def generate 
        @evac_center = EvacCenter.find(params[:evac_center])
        @disaster = Disaster.find(params[:disaster_id])
        @agegroup = ["INFANT", "TODDLERS", "Preschoolers", "Schoolage","Teenage", "Adult", "Senior Citizens"]
        respond_to do |format|
            format.html
            format.csv 
        end
    end
end
