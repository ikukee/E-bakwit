class GenerateReportController < ApplicationController
    
    def generate ## evac_centers/1/:disaster/generate
        @evac_center = EvacCenter.find(params[:evac_center])
        @disaster = Disaster.find(params[:disaster_id])
        reliefGoods = ReliefGood.where("evac_center = ? AND disaster = ?").all
        result = CSV.generate do |csv|
            ## EVACUEE
            csv << ["GENERATED AS OF", Time.current]
            csv << ["DISASTER NAME", @disaster.name, "DISASTER TYPE",@disaster.disaster_type,"DATE OF OCCURENCE", @disaster.date_of_occurence]
            csv << ["EVACUATION CENTER", @evac_center.name, "ADDRESS",@evac_center.barangay]
            csv << ["Age Range", "No. Of MALEs", "No. Of FEMALEs", "TOTAL"]
            csv << ["INFANT", helpers.getInfants(@evac_center.id, @disaster.id,"Male"),helpers.getInfants(@evac_center.id, @disaster.id,"Female"),helpers.getInfants(@evac_center.id, @disaster.id,"Male") + helpers.getInfants(@evac_center.id, @disaster.id,"Female")]
            csv << ["TODDLER", helpers.getToddlers(@evac_center.id, @disaster.id,"Male"), helpers.getToddlers(@evac_center.id, @disaster.id,"Female"),helpers.getToddlers(@evac_center.id, @disaster.id,"Male") + helpers.getToddlers(@evac_center.id, @disaster.id,"Female")]
            csv << ["PRESCHOOLERS",helpers.getPreschoolers(@evac_center.id, @disaster.id,"Male"),helpers.getPreschoolers(@evac_center.id, @disaster.id,"Female"),helpers.getPreschoolers(@evac_center.id, @disaster.id,"Male") + helpers.getPreschoolers(@evac_center.id, @disaster.id,"Female")]
            csv << ["SCHOOLAGERS",helpers.getSchoolagers(@evac_center.id, @disaster.id,"Male"),helpers.getSchoolagers(@evac_center.id, @disaster.id,"Female"),helpers.getSchoolagers(@evac_center.id, @disaster.id,"Male") + helpers.getSchoolagers(@evac_center.id, @disaster.id,"Female")]
            csv << ["TEENAGERS",helpers.getTeenagers(@evac_center.id, @disaster.id,"Male"),helpers.getTeenagers(@evac_center.id, @disaster.id,"Female"),helpers.getTeenagers(@evac_center.id, @disaster.id,"Male") + helpers.getTeenagers(@evac_center.id, @disaster.id,"Female")]
            csv << ["ADULTS",helpers.getAdults(@evac_center.id, @disaster.id,"Male"),helpers.getAdults(@evac_center.id, @disaster.id,"Female"),helpers.getAdults(@evac_center.id, @disaster.id,"Male") + helpers.getAdults(@evac_center.id, @disaster.id,"Female")]
            csv << ["SENIORS",helpers.getSeniors(@evac_center.id, @disaster.id,"Male"),helpers.getSeniors(@evac_center.id, @disaster.id,"Female"),helpers.getSeniors(@evac_center.id, @disaster.id,"Male") + helpers.getSeniors(@evac_center.id, @disaster.id,"Female")]
            csv << ["TOTAL",helpers.countGenderEvacuated(@evac_center.id,@disaster, "Male"),helpers.countGenderEvacuated(@evac_center.id,@disaster, "Female"),helpers.countGenderEvacuated(@evac_center.id,@disaster, "Male") + helpers.countGenderEvacuated(@evac_center.id,@disaster, "Female")]
            ##RELIEF
            ## csv << ["Name", "Unit of Measurement", "Quantity", "Cost"]
            #reliefGoods.each do |relief|
                #csv << [relief.name, relief.unit, relief.quantity, relief.cost]
           # end
            
        end
        respond_to do |format|
            format.html
            format.xls {send_data result, filename: "#{@disaster.name}-#{@disaster.date_of_occurence}-#{@evac_center.name}.xls", type: 'text/xls; charset=utf-8'}
            format.csv {send_data result, filename: "#{@disaster.name}-#{@disaster.date_of_occurence}-#{@evac_center.name}.csv", type: 'text/csv; charset=utf-8'}
        end
    end
    def generate_all # disasters/1/generate
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
        result = CSV.generate do |csv|
            csv << ["GENERATED AS OF", Time.current]
            csv << ["EVACUATION REPORT OF NAGA CITY"]
            csv << ["DISASTER NAME", @disaster.name, "DISASTER TYPE",@disaster.disaster_type,"DATE OF OCCURENCE", @disaster.date_of_occurence]
            csv << ["BARANGAY", "", "EVACUATION CENTER", ""].concat(age_group)
            csv << ["GRAND TOTAL", barangay_group.length, "",EvacCenter.all.length, @infantM, @infatF, @toddlerM, @toddlerF,@preschoolersM,@preschoolersF,@schoolageM,@schoolageF,@teenageM,@teenageF,@adultM,@adultF,@seniorM,@seniorM]
            barangay_group.each do |brgy|
                csv << [brgy, "","", limiterForBarangay(brgy),]
                @evac_centers.each do |center|
                    if center.barangay == brgy
                        csv << ["", "", center.name, "1",
                            helpers.getInfants(center.id, @disaster.id, "Male"),
                            helpers.getInfants(center.id, @disaster.id, "Female"),
                            helpers.getToddlers(center.id, @disaster.id, "Male"),
                            helpers.getToddlers(center.id, @disaster.id, "Female"),
                            helpers.getPreschoolers(center.id, @disaster.id, "Male"),
                            helpers.getPreschoolers(center.id, @disaster.id, "Female"),
                            helpers.getSchoolagers(center.id, @disaster.id, "Male"),
                            helpers.getSchoolagers(center.id, @disaster.id, "Female"),
                            helpers.getTeenagers(center.id, @disaster.id, "Male"),
                            helpers.getTeenagers(center.id, @disaster.id, "Female"),
                            helpers.getAdults(center.id, @disaster.id, "Male"),
                            helpers.getAdults(center.id, @disaster.id, "Female"),
                            helpers.getSeniors(center.id, @disaster.id, "Male"),                         
                            helpers.getSeniors(center.id, @disaster.id, "Female"),
                        ]
                    end
                end
            end
        end
        respond_to do |format|
            format.html {render result}
            format.xls {send_data result, filename: "#{@disaster.name}-#{@disaster.date_of_occurence}.xls", type: 'text/xls; charset=utf-8'}
            format.csv {send_data result, filename: "#{@disaster.name}-#{@disaster.date_of_occurence}.csv", type: 'text/csv; charset=utf-8'}
        end
    end
    private

    def limiterForBarangay(brgy)
        x = EvacCenter.where("BARANGAY = ?", brgy).all.length
        if(x > 0)
            return x 
        else 
            return "" 
        end 
    end

    def age_group 
        titles = ["INFANT(MALE)", "INFANT(FEMALE)", "TODDLERS(MALE)","TODDLERS(FEMALE)", "PRESCHOOLER(MALE)", "PRESCHOOLER(FEMALE)", "SCHOOLAGE(MALE)", "SCHOOLAGE(FEMALE)","TEENAGE(MALE)","TEENAGE(FEMALE)", "ADULT(MALE)", "ADULT(FEMALE)", "SENIOR CITIZEN(MALE)", "SENIOR CITIZEN(FEMALE)"]
    end
    def barangay_group
        titles = [
            "Abella", "Bagumbayan Norte", "Bagumbayan Sur", "Balatas", 
            "Calauag", "Cararayan", "Carolina", "Concepcion Grande", 
            "Concepcion Pequeña", "Dayangdang", "Del Rosario", "Dinaga", 
            "Igualdad Interior","Lerma","Liboton", "Mabolo", "Pacol", 
            "Panicuason", "Peñafrancia", "Sabang", "San Felipe", 
            "San Francisco", "San Isidro", "Santa Cruz", "Tabuco", 
            "Tinago", "Triangulo"
        ]
    end
end
