class GenerateReportController < ApplicationController
    def generate 
        @evac_center = EvacCenter.find(params[:evac_center])
        @disaster = Disaster.find(params[:disaster_id])
        
        respond_to do |format|
            format.html
            format.csv 
        end
    end
    def generate_all
        ## GRAND TOTAL OF ALL EVAC CENTERS
        @infantM = 0
        @toddlerM = 0
        @preschoolersM = 0
        @schoolageM = 0
        @teenageM = 0
        @adultM = 0
        @seniorM = 0

        @infantF = 0
        @toddlerF = 0
        @preschoolersF = 0
        @schoolageF = 0
        @teenageF = 0
        @adultF = 0
        @seniorF = 0

        @disaster = Disaster.find(params[:disaster_id])
        @evac_centers = EvacCenter.all
        @evac_centers.each do |center|
            @infantM = @infantM + helpers.getInfants(center.id, @disaster.id, "Male")
            @toddlerM = @toddlerM + helpers.getToddlers(center.id, @disaster.id, "Male")
            @preschoolersM = @preschoolersM + helpers.getPreschoolers(center.id, @disaster.id, "Male")
            @schoolageM = @schoolageM + helpers.getSchoolagers(center.id, @disaster.id, "Male")
            @teenageM = @teenageM + helpers.getTeenagers(center.id, @disaster.id, "Male")
            @adultM = @adultM + helpers.getAdults(center.id, @disaster.id, "Male")
            @seniorM = @seniorM + helpers.getSeniors(center.id, @disaster.id, "Male")

            @infantF = @infantF + helpers.getInfants(center.id, @disaster.id, "Female")
            @toddlerF = @toddlerF + helpers.getToddlers(center.id, @disaster.id, "Female")
            @preschoolersF = @preschoolersF + helpers.getPreschoolers(center.id, @disaster.id, "Female")
            @schoolageF = @schoolageF + helpers.getSchoolagers(center.id, @disaster.id, "Female")
            @teenageF = @teenageF + helpers.getTeenagers(center.id, @disaster.id, "Female")
            @adultF = @adultF + helpers.getAdults(center.id, @disaster.id, "Female")
            @seniorF = @seniorF + helpers.getSeniors(center.id, @disaster.id, "Female")
        
        end
        respond_to do |format|
            format.html
            format.csv
        end

    end
    private

    def age_group 
        titles = ["INFANT", "TODDLERS", "Preschoolers", "Schoolage","Teenage", "Adult", "Senior Citizens"]
    end

end
