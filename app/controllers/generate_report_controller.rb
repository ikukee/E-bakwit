class GenerateReportController < ApplicationController
    before_action :is_logged_in
    require 'axlsx'
    helper_method :barangay_group
    def viewSpecificReport
        @evac_center = EvacCenter.find(params[:evac_center])
        @disaster = Disaster.find(params[:disaster_id])
        @tprice = 0
        @rlGoods = []
        @essFaci = []
        @yProf = EvacYearlyProfile.all.where(evac_id: @evac_center.id).where(year: @disaster.year).each do |yp|
            AssignedYearlyEss.all.where(evac_profile_id: yp.id).each do |ye|
                @essFaci.push([EvacuationEssential.find(ye.ess_id).name,EvacuationEssential.find(ye.ess_id).ess_type, EvacuationEssential.find(ye.ess_id).description, ye.quantity, ye.status])
            end
        end
        GenRgAlloc.all.where("disaster_id = ? AND evac_id = ?", @disaster.id , @evac_center.id).each do |rg|
            @rlGoods.push([rg.name, "#{ReliefGood.find(rg.rg_id).unit } / #{ReliefGood.find(rg.rg_id).price }" , rg.price / ReliefGood.find(rg.rg_id).price, rg.price])
            if ReliefGood.find(rg.rg_id).is_food == true
                @tprice = @tprice + rg.price
            elsif ReliefGood.find(rg.rg_id).is_food == false
                @tprice = @tprice + rg.price
            else
                @tprice = @tprice + rg.price
            end
        end
        respond_to do |format|
            format.html
        end
    end
    def viewGeneralReport
        @totalfamily = 0
        @totalPersons = 0
        @totalfamily4ps = 0
        @CumFamilies = 0
        @NowFamilies = 0
        @CumPerson = 0
        @NowPerson = 0
        @affectedEvac = 0
        # DEMOGRAPHICS
        @infantM = 0
        @toddlerM = 0
        @preschoolersM = 0
        @schoolageM = 0
        @teenageM = 0
        @adultM = 0
        @seniorM = 0

        @infantM_now = 0
        @toddlerM_now = 0
        @preschoolersM_now = 0
        @schoolageM_now = 0
        @teenageM_now = 0
        @adultM_now = 0
        @seniorM_now = 0

        @infantF = 0
        @toddlerF = 0
        @preschoolersF = 0
        @schoolageF = 0
        @teenageF = 0
        @adultF = 0
        @seniorF = 0

        @infantF_now = 0
        @toddlerF_now = 0
        @preschoolersF_now = 0
        @schoolageF_now = 0
        @teenageF_now = 0
        @adultF_now = 0
        @seniorF_now = 0
        ## RELIEF GOODS PART
        @tprice = 0
        @tnfprice =0
        @tfprice =0
        @rlGoods = []
        @essFaciTitles = []
        @barangays = []
        barangay_group.each do |x|
            @barangays.push(x)
        end
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

            @infantM_now += helpers.ggetInfants(center.id, @disaster.id, "Male",true)
            @toddlerM_now+= helpers.ggetToddlers(center.id, @disaster.id, "Male",true)
            @preschoolersM_now += helpers.ggetPreschoolers(center.id, @disaster.id, "Male",true)
            @schoolageM_now += helpers.ggetSchoolagers(center.id, @disaster.id, "Male",true)
            @teenageM_now += helpers.ggetTeenagers(center.id, @disaster.id, "Male",true)
            @adultM_now += helpers.ggetAdults(center.id, @disaster.id, "Male",true)
            @seniorM_now += helpers.ggetSeniors(center.id, @disaster.id, "Male",true)

            @infantF_now += helpers.ggetInfants(center.id, @disaster.id, "Female",true)
            @toddlerF_now += helpers.ggetToddlers(center.id, @disaster.id, "Female",true)
            @preschoolersF_now += helpers.ggetPreschoolers(center.id, @disaster.id, "Female",true)
            @schoolageF_now += helpers.ggetSchoolagers(center.id, @disaster.id, "Female",true)
            @teenageF_now += helpers.ggetTeenagers(center.id, @disaster.id, "Female",true)
            @adultF_now += helpers.ggetAdults(center.id, @disaster.id, "Female",true)
            @seniorF_now += helpers.ggetSeniors(center.id, @disaster.id, "Female",true)

            @totalfamily += countServedFamily(center.id, @disaster.id, false)
            @totalPersons += countIndivEvacuated(center.id, @disaster.id, false)
            @CumFamilies += countServedFamily(center.id, @disaster.id, false)
            @NowFamilies += countServedFamily(center.id, @disaster.id, true)
            @CumPerson +=countIndivEvacuated(center.id, @disaster.id, false)
            @NowPerson +=countIndivEvacuated(center.id, @disaster.id, true)
            @totalfamily4ps +=countServedFamily4ps(center.id, @disaster.id, false)

            if(countServedFamily(center.id, @disaster.id, false) > 0)
                @affectedEvac +=1
            end
            GenRgAlloc.all.where("disaster_id = ? AND evac_id = ?", @disaster.id , center.id).each do |rg|
                @rlGoods.push([rg.name, "#{ReliefGood.find(rg.rg_id).unit } / #{ReliefGood.find(rg.rg_id).price }" , rg.price / ReliefGood.find(rg.rg_id).price, rg.price])
                if ReliefGood.find(rg.rg_id).is_food == true
                    @tprice = @tprice + rg.price
                    @tfprice += rg.price
                elsif ReliefGood.find(rg.rg_id).is_food == false
                    @tprice = @tprice + rg.price
                    @tnfprice += rg.price
                else
                    @tprice = @tprice + rg.price
                end
            end

            @yProf = EvacYearlyProfile.all.where(evac_id: center.id).where(year: @disaster.year).each do |yp|
                AssignedYearlyEss.all.where(evac_profile_id: yp.id).each do |ye|
                    @essFaciTitles.push(EvacuationEssential.find(ye.ess_id).name);
                    #essFaci.push([EvacuationEssential.find(ye.ess_id).name,EvacuationEssential.find(ye.ess_id).ess_type, EvacuationEssential.find(ye.ess_id).description, ye.quantity, ye.status])
                end
            end
        end
        respond_to do |format|
            format.html
        end
    end
    def generate ## evac_centers/1/:disaster/generate
        @evac_center = EvacCenter.find(params[:evac_center])
        @disaster = Disaster.find(params[:disaster_id])
        reliefGoods = ReliefGood.where("evac_center = ? AND disaster = ?").all

        @tprice = 0
        @rlGoods = []
        @essFaci = []
        @yProf = EvacYearlyProfile.all.where(evac_id: @evac_center.id).where(year: @disaster.year).each do |yp|
            AssignedYearlyEss.all.where(evac_profile_id: yp.id).each do |ye|
                @essFaci.push([EvacuationEssential.find(ye.ess_id).name,EvacuationEssential.find(ye.ess_id).ess_type, EvacuationEssential.find(ye.ess_id).description, ye.quantity, ye.status])
            end
        end
        GenRgAlloc.all.where("disaster_id = ? AND evac_id = ?", @disaster.id , @evac_center.id).each do |rg|
            @rlGoods.push([rg.name, "#{ReliefGood.find(rg.rg_id).unit } / #{ReliefGood.find(rg.rg_id).price }" , rg.price / ReliefGood.find(rg.rg_id).price, rg.price])
            if ReliefGood.find(rg.rg_id).is_food == true
                @tprice = @tprice + rg.price
            elsif ReliefGood.find(rg.rg_id).is_food == false
                @tprice = @tprice + rg.price
            else
                @tprice = @tprice + rg.price
            end
        end
        p = Axlsx::Package.new
        wb = p.workbook
        s = wb.styles
        defaultColorHead = s.add_style bg_color: '9fc5e8'
        grandTotalHeader = s.add_style bg_color: '7f7f7f'
        brngyHeader = s.add_style bg_color: 'a5a5a5'
        wb.add_worksheet(name: "#{@disaster.name}_#{@disaster.date_of_occurence}") do |sheet|
            sheet.add_row ["Report Number"]
            sheet.add_row ["GENERATED AS OF", Time.current, "GENERATED BY", User.find(session[:user_id]).full_name, "EMAIL", User.find(session[:user_id]).email, "MOBILE No.", User.find(session[:user_id]).cnum]
            sheet.add_row ["INCIDENT NAME", @disaster.name, "DISASTER TYPE",@disaster.disaster_type,"DATE OF OCCURENCE", @disaster.date_of_occurence].concat(whitespacer(2))
            sheet.add_row ["EVACUATION CENTER", @evac_center.name, "ADDRESS","#{@evac_center.barangay}, Naga City, Camarines Sur"].concat(whitespacer(4)),style:defaultColorHead
            #
            sheet.add_row ["NOTED BY"].concat(whitespacer(7)),style:defaultColorHead
            sheet.add_row [""].concat(whitespacer(7)),style:defaultColorHead
            sheet.sheet_view.pane do |pane|
                pane.top_left_cell = "A10"
                pane.state = :frozen_split
                pane.y_split = 9
                pane.x_split = 0
                pane.active_pane = :bottom_right
            end
            sheet.add_row ["Age Range", "No. Of MALEs","", "No. Of FEMALEs",""].concat(whitespacer(3))
            sheet.add_row ["", "CUM", "NOW", "CUM", "NOW"].concat(whitespacer(3))
            sheet.add_row ["GRAND TOTAL",helpers.gcountGenderEvacuated(@evac_center.id,@disaster, "Male", false),helpers.gcountGenderEvacuated(@evac_center.id,@disaster, "Male", true),helpers.gcountGenderEvacuated(@evac_center.id,@disaster, "Female", false),helpers.gcountGenderEvacuated(@evac_center.id,@disaster, "Female", true)].concat(whitespacer(3)),style: grandTotalHeader
            sheet.add_row ["INFANT", helpers.ggetInfants(@evac_center.id, @disaster.id,"Male", false),helpers.ggetInfants(@evac_center.id, @disaster.id,"Male", true),helpers.ggetInfants(@evac_center.id, @disaster.id,"Female", false),helpers.ggetInfants(@evac_center.id, @disaster.id,"Female", true)].concat(whitespacer(3))
            sheet.add_row ["TODDLER", helpers.ggetToddlers(@evac_center.id, @disaster.id,"Male", false), helpers.ggetToddlers(@evac_center.id, @disaster.id,"Male", true),helpers.ggetToddlers(@evac_center.id, @disaster.id,"Female", false),helpers.ggetToddlers(@evac_center.id, @disaster.id,"Female", true)].concat(whitespacer(3))
            sheet.add_row ["PRESCHOOLERS",helpers.ggetPreschoolers(@evac_center.id, @disaster.id,"Male", false),helpers.ggetPreschoolers(@evac_center.id, @disaster.id,"Male", true),helpers.ggetPreschoolers(@evac_center.id, @disaster.id,"Female", false),helpers.ggetPreschoolers(@evac_center.id, @disaster.id,"Female", true)].concat(whitespacer(3))
            sheet.add_row ["SCHOOLAGERS",helpers.ggetSchoolagers(@evac_center.id, @disaster.id,"Male", false),helpers.ggetSchoolagers(@evac_center.id, @disaster.id,"Male", true),helpers.ggetSchoolagers(@evac_center.id, @disaster.id,"Female", false),helpers.ggetSchoolagers(@evac_center.id, @disaster.id,"Female", true)].concat(whitespacer(3))
            sheet.add_row ["TEENAGERS",helpers.ggetTeenagers(@evac_center.id, @disaster.id,"Male", false),helpers.ggetTeenagers(@evac_center.id, @disaster.id,"Male", true),helpers.ggetTeenagers(@evac_center.id, @disaster.id,"Female", false),helpers.ggetTeenagers(@evac_center.id, @disaster.id,"Female", true)].concat(whitespacer(3))
            sheet.add_row ["ADULTS",helpers.ggetAdults(@evac_center.id, @disaster.id,"Male", false),helpers.ggetAdults(@evac_center.id, @disaster.id,"Male", true),helpers.ggetAdults(@evac_center.id, @disaster.id,"Female", false),helpers.ggetAdults(@evac_center.id, @disaster.id,"Female", true)].concat(whitespacer(3))
            sheet.add_row ["SENIORS",helpers.ggetSeniors(@evac_center.id, @disaster.id,"Male", false),helpers.ggetSeniors(@evac_center.id, @disaster.id,"Male", true),helpers.ggetSeniors(@evac_center.id, @disaster.id,"Female", false),helpers.ggetSeniors(@evac_center.id, @disaster.id,"Female", true)].concat(whitespacer(3))

            sheet.merge_cells('B7:C7')
            sheet.merge_cells('D7:E7')
            sheet.merge_cells('A7:A8')
            sheet["A7:H8"].each do |cell|
                cell.style = wb.styles.add_style({bg_color:"c5e0b3", :alignment => {:horizontal => :center, :vertical => :center, :wrap_text => true}})
            end

        end
        wb.add_worksheet(name: "RELIEF GOODS RECIEVED") do |sheet|
            sheet.add_row ["Report Number"]
            sheet.add_row ["GENERATED AS OF", Time.current, "GENERATED BY", User.find(session[:user_id]).full_name, "EMAIL", User.find(session[:user_id]).email, "MOBILE No.", User.find(session[:user_id]).cnum]
            sheet.add_row ["INCIDENT NAME", @disaster.name, "DISASTER TYPE",@disaster.disaster_type,"DATE OF OCCURENCE", @disaster.date_of_occurence].concat(whitespacer(2))
            sheet.add_row ["EVACUATION CENTER", @evac_center.name, "ADDRESS","#{@evac_center.barangay}, Naga City, Camarines Sur"].concat(whitespacer(4)),style:defaultColorHead
            #
            sheet.add_row ["NOTED BY"].concat(whitespacer(7)),style:defaultColorHead
            sheet.add_row [""].concat(whitespacer(7)),style:defaultColorHead
            sheet.sheet_view.pane do |pane|
                pane.top_left_cell = "A10"
                pane.state = :frozen_split
                pane.y_split = 9
                pane.x_split = 0
                pane.active_pane = :bottom_right
            end
            sheet.add_row ["RELIEF GOODS RECIEVED"].concat(whitespacer(7))

            sheet.add_row ["NAME", "UNIT / PRICE", "QUANTITY", "CUMULATIVE PRICE"].concat(whitespacer(4))
            sheet["A7:H8"].each do |cell|
                cell.style = wb.styles.add_style({bg_color:"c5e0b3",:alignment => {:horizontal => :center, :vertical => :center, :wrap_text => true}})
            end
            sheet.add_row ["GRAND TOTAL"].concat(whitespacer(2),[@tprice],whitespacer(4)),style: grandTotalHeader
            @rlGoods.each do |rlG|
                sheet.add_row rlG
            end

        end
        wb.add_worksheet(name: "EVACUATION CENTER FACILITIES") do |sheet|
            sheet.add_row ["Report Number"]
            sheet.add_row ["GENERATED AS OF", Time.current, "GENERATED BY", User.find(session[:user_id]).full_name, "EMAIL", User.find(session[:user_id]).email, "MOBILE No.", User.find(session[:user_id]).cnum]
            sheet.add_row ["INCIDENT NAME", @disaster.name, "DISASTER TYPE",@disaster.disaster_type,"DATE OF OCCURENCE", @disaster.date_of_occurence].concat(whitespacer(2))
            sheet.add_row ["EVACUATION CENTER", @evac_center.name, "ADDRESS","#{@evac_center.barangay}, Naga City, Camarines Sur"].concat(whitespacer(4)),style:defaultColorHead
            #
            sheet.add_row ["NOTED BY"].concat(whitespacer(7)),style:defaultColorHead
            sheet.add_row [""].concat(whitespacer(7)),style:defaultColorHead
            sheet.sheet_view.pane do |pane|
                pane.top_left_cell = "A10"
                pane.state = :frozen_split
                pane.y_split = 9
                pane.x_split = 0
                pane.active_pane = :bottom_right
            end
            sheet.add_row ["FACILITIES AND ESSENTIALS"].concat(whitespacer(7))
            sheet.add_row [""].concat(whitespacer(7))
            sheet.add_row ["NAME", "TYPE", "DESCRIPTION", "QUANTITY", "QUALITY"].concat(whitespacer(3))
            @essFaci.each do |rlG|
                sheet.add_row rlG
            end
            sheet.merge_cells("A7:E7")
            sheet["A7:H9"].each do |cell|
                cell.style = wb.styles.add_style({bg_color:"c5e0b3",:alignment => {:horizontal => :center, :vertical => :center, :wrap_text => true}})
            end
        end

        p.serialize "#{Rails.root}/tmp/generate.xlsx"
        #.serialize "#{Rails.root}/app/views/generate_report/generate.xlsx.axlsx"
        send_file("#{Rails.root}/tmp/generate.xlsx", filename:"#{@disaster.name}-#{@disaster.date_of_occurence}-#{@evac_center.name}.xlsx", type: "application/xlsx",disposition: 'inline')

        #render file: "#{Rails.root}/tmp/generate.xlsx.axlsx", layout: true
        

    end
    def generate_all # disasters/1/generate
        ## GRAND TOTAL OF ALL EVAC CENTERS
        p = Axlsx::Package.new
        wb = p.workbook
        @totalfamily = 0
        @totalPersons = 0
        @totalfamily4ps = 0
        @CumFamilies = 0
        @NowFamilies = 0
        @CumPerson = 0
        @NowPerson = 0
        @affectedEvac = 0
        # DEMOGRAPHICS
        @infantM = 0
        @toddlerM = 0
        @preschoolersM = 0
        @schoolageM = 0
        @teenageM = 0
        @adultM = 0
        @seniorM = 0

        @infantM_now = 0
        @toddlerM_now = 0
        @preschoolersM_now = 0
        @schoolageM_now = 0
        @teenageM_now = 0
        @adultM_now = 0
        @seniorM_now = 0

        @infantF = 0
        @toddlerF = 0
        @preschoolersF = 0
        @schoolageF = 0
        @teenageF = 0
        @adultF = 0
        @seniorF = 0

        @infantF_now = 0
        @toddlerF_now = 0
        @preschoolersF_now = 0
        @schoolageF_now = 0
        @teenageF_now = 0
        @adultF_now = 0
        @seniorF_now = 0
        ## RELIEF GOODS PART
        @tprice = 0
        @tnfprice =0
        @tfprice =0
        rlGoods = []
        essFaciTitles = [""]
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

            @infantM_now += helpers.ggetInfants(center.id, @disaster.id, "Male",true)
            @toddlerM_now+= helpers.ggetToddlers(center.id, @disaster.id, "Male",true)
            @preschoolersM_now += helpers.ggetPreschoolers(center.id, @disaster.id, "Male",true)
            @schoolageM_now += helpers.ggetSchoolagers(center.id, @disaster.id, "Male",true)
            @teenageM_now += helpers.ggetTeenagers(center.id, @disaster.id, "Male",true)
            @adultM_now += helpers.ggetAdults(center.id, @disaster.id, "Male",true)
            @seniorM_now += helpers.ggetSeniors(center.id, @disaster.id, "Male",true)

            @infantF_now += helpers.ggetInfants(center.id, @disaster.id, "Female",true)
            @toddlerF_now += helpers.ggetToddlers(center.id, @disaster.id, "Female",true)
            @preschoolersF_now += helpers.ggetPreschoolers(center.id, @disaster.id, "Female",true)
            @schoolageF_now += helpers.ggetSchoolagers(center.id, @disaster.id, "Female",true)
            @teenageF_now += helpers.ggetTeenagers(center.id, @disaster.id, "Female",true)
            @adultF_now += helpers.ggetAdults(center.id, @disaster.id, "Female",true)
            @seniorF_now += helpers.ggetSeniors(center.id, @disaster.id, "Female",true)

            @totalfamily += countServedFamily(center.id, @disaster.id, false)
            @totalPersons += countIndivEvacuated(center.id, @disaster.id, false)
            @CumFamilies += countServedFamily(center.id, @disaster.id, false)
            @NowFamilies += countServedFamily(center.id, @disaster.id, true)
            @CumPerson +=countIndivEvacuated(center.id, @disaster.id, false)
            @NowPerson +=countIndivEvacuated(center.id, @disaster.id, true)
            @totalfamily4ps +=countServedFamily4ps(center.id, @disaster.id, false)

            if(countServedFamily(center.id, @disaster.id, false) > 0)
                @affectedEvac +=1
            end
            GenRgAlloc.all.where("disaster_id = ? AND evac_id = ?", @disaster.id , center.id).each do |rg|
                rlGoods.push([rg.name, "#{ReliefGood.find(rg.rg_id).unit } / #{ReliefGood.find(rg.rg_id).price }" , rg.price / ReliefGood.find(rg.rg_id).price, rg.price])
                if ReliefGood.find(rg.rg_id).is_food == true
                    @tprice = @tprice + rg.price
                    @tfprice += rg.price
                elsif ReliefGood.find(rg.rg_id).is_food == false
                    @tprice = @tprice + rg.price
                    @tnfprice += rg.price
                else
                    @tprice = @tprice + rg.price
                end
            end

            @yProf = EvacYearlyProfile.all.where(evac_id: center.id).where(year: @disaster.year).each do |yp|
                AssignedYearlyEss.all.where(evac_profile_id: yp.id).each do |ye|
                    essFaciTitles.push(EvacuationEssential.find(ye.ess_id).name);
                    #essFaci.push([EvacuationEssential.find(ye.ess_id).name,EvacuationEssential.find(ye.ess_id).ess_type, EvacuationEssential.find(ye.ess_id).description, ye.quantity, ye.status])
                end
            end
        end

        s = wb.styles
        grandTotalHeader = s.add_style bg_color: '7f7f7f'
        brngyHeader = s.add_style bg_color: 'a5a5a5'
        defaultColorHead = s.add_style bg_color: '9fc5e8', :alignment => {:horizontal => :center, :vertical => :center, :wrap_text => true}
        worksheet_name ="#{@disaster.name}_#{@disaster.date_of_occurence}"

        wb.add_worksheet(name:worksheet_name ) do |sheet|
            sheet.add_row ["Report Number"]
            sheet.add_row ["GENERATED AS OF", Time.current, "GENERATED BY", User.find(session[:user_id]).full_name, "EMAIL", User.find(session[:user_id]).email, "MOBILE No.", User.find(session[:user_id]).cnum]
            sheet.add_row ["INCIDENT NAME", @disaster.name, "DISASTER TYPE",@disaster.disaster_type,"DATE OF OCCURENCE", @disaster.date_of_occurence]
            sheet.add_row ["NOTED BY"]
            sheet.add_row ["BARANGAY", "Number of Affected"].concat(whitespacer(4)).concat(["Number of Displaced Inside ECs"]).concat(whitespacer(3),age_groupT(true, 3)).concat(whitespacer(essFaciTitles.length+3)),style:defaultColorHead
            sheet.add_row [""].concat(whitespacer(5)).concat(["FAMILIES","","PERSONS"]).concat(whitespacer(1), malefemale(7),whitespacer(1), ["TOTAL COST OF ASSISTANCE", ""]).concat(whitespacer(1),["EVACUATION CENTER FACILITIES"]).concat(whitespacer(essFaciTitles.length-2)),style:defaultColorHead
            sheet.add_row ["", "EVACUATION CENTER", "COUNT","FAMILIES","PERSONS","4Ps FAMILIES"].concat(cumnow(8), ["","FOOD", "NON-FOOD"],essFaciTitles),style:defaultColorHead
            sheet.add_row ["GRAND TOTAL", EvacCenter.all.length,@affectedEvac,
            @totalfamily, @totalPersons, @totalfamily4ps, @CumFamilies, @NowFamilies, @CumPerson, @NowPerson, @infantM,@infantM_now, @infantF, @infantF_now,
            @toddlerM,@toddlerM_now, @toddlerF,@toddlerF_now,
            @preschoolersM,@preschoolersM_now,@preschoolersF,@preschoolersF_now,
            @schoolageM,@schoolageM_now,@schoolageF,@schoolageF_now,
            @teenageM,@teenageM_now,@teenageF,@teenageF_now,
            @adultM,@adultM_now,@adultF,@adultF_now,
            @seniorM,@seniorM_now,@seniorM,@seniorM_now].concat(whitespacer(1), [@tfprice,@tnfprice]).concat(whitespacer(essFaciTitles.length)), style: grandTotalHeader
            sheet.sheet_view.pane do |pane|
                pane.top_left_cell = "B8:C8"
                pane.state = :frozen_split
                pane.y_split = 8
                pane.x_split = 2
                pane.active_pane = :bottom_right
            end
            barangay_group.each do |brgy|
                sheet.add_row ["#{brgy}", limiterForBarangay(brgy)].concat(whitespacer(39 + essFaciTitles.length)), style: brngyHeader
                @evac_centers.each do |center|

                    if center.barangay == brgy
                        sheet.add_row ["", center.name,
                            helpers.countServedFamilyType(countServedFamily(center.id, @disaster.id, false)),
                            countServedFamily(center.id, @disaster.id, false),
                            countIndivEvacuated(center.id, @disaster.id, false),
                            countServedFamily4ps(center.id, @disaster.id, false),
                            countServedFamily(center.id, @disaster.id, false),
                            countServedFamily(center.id, @disaster.id, true),
                            countIndivEvacuated(center.id, @disaster.id, false),
                            countIndivEvacuated(center.id, @disaster.id, true),

                            helpers.getInfants(center.id, @disaster.id, "Male"),
                            helpers.ggetInfants(center.id, @disaster.id, "Male", true),
                            helpers.getInfants(center.id, @disaster.id, "Female"),
                            helpers.ggetInfants(center.id, @disaster.id, "Female", true),

                            helpers.getToddlers(center.id, @disaster.id, "Male"),
                            helpers.ggetToddlers(center.id, @disaster.id, "Male", true),
                            helpers.getToddlers(center.id, @disaster.id, "Female"),
                            helpers.ggetToddlers(center.id, @disaster.id, "Female",true),

                            helpers.getPreschoolers(center.id, @disaster.id, "Male"),
                            helpers.ggetPreschoolers(center.id, @disaster.id, "Male",true),
                            helpers.getPreschoolers(center.id, @disaster.id, "Female"),
                            helpers.ggetPreschoolers(center.id, @disaster.id, "Female",true),

                            helpers.getSchoolagers(center.id, @disaster.id, "Male"),
                            helpers.ggetSchoolagers(center.id, @disaster.id, "Male",true),
                            helpers.getSchoolagers(center.id, @disaster.id, "Female"),
                            helpers.ggetSchoolagers(center.id, @disaster.id, "Female",true),

                            helpers.getTeenagers(center.id, @disaster.id, "Male"),
                            helpers.ggetTeenagers(center.id, @disaster.id, "Male",true),
                            helpers.getTeenagers(center.id, @disaster.id, "Female"),
                            helpers.ggetTeenagers(center.id, @disaster.id, "Female",true),

                            helpers.getAdults(center.id, @disaster.id, "Male"),
                            helpers.ggetAdults(center.id, @disaster.id, "Male",true),
                            helpers.getAdults(center.id, @disaster.id, "Female"),
                            helpers.ggetAdults(center.id, @disaster.id, "Female",true),

                            helpers.getSeniors(center.id, @disaster.id, "Male"),
                            helpers.ggetSeniors(center.id, @disaster.id, "Male",true),
                            helpers.getSeniors(center.id, @disaster.id, "Female"),
                            helpers.ggetSeniors(center.id, @disaster.id, "Female",true),
                    ].concat(whitespacer(1),[getReliefCost(center.id, @disaster.id,true),getReliefCost(center.id, @disaster.id,false), ""], getQuantity(center.id, @disaster))
                    end
                end
            end
            sheet.merge_cells("G6:H6")
            sheet.merge_cells("I6:J6")
            sheet.merge_cells("A5:A7")
            sheet.merge_cells("B5:F6")
            sheet.merge_cells("G5:J5")
            sheet.merge_cells("K6:L6")
            sheet.merge_cells("M6:N6")
            sheet.merge_cells("O6:P6")
            sheet.merge_cells("Q6:R6")
            sheet.merge_cells("K6:L6")
            sheet.merge_cells("M6:N6")
            sheet.merge_cells("O6:P6")
            sheet.merge_cells("Q6:R6")
            sheet.merge_cells("S6:T6")
            sheet.merge_cells("U6:V6")
            sheet.merge_cells("W6:X6")
            sheet.merge_cells("Y6:Z6")

            # sex
            sheet.merge_cells("AA6:AB6")
            sheet.merge_cells("AC6:AD6")
            sheet.merge_cells("AE6:AF6")
            sheet.merge_cells("AG6:AH6")
            sheet.merge_cells("AI6:AJ6")
            sheet.merge_cells("AK6:AL6")

            # age group
            sheet.merge_cells("K5:N5")
            sheet.merge_cells("O5:R5")
            sheet.merge_cells("S5:V5")
            sheet.merge_cells("W5:Z5")
            sheet.merge_cells("AA5:AD5")
            sheet.merge_cells("AE5:AH5")
            sheet.merge_cells("AI5:AL5")

            #faciliteis
            sheet.merge_cells("AN6:AO6")
            sheet["B5:F7"].each do |cell|
                cell.style = wb.styles.add_style({bg_color:"c5e0b3",:alignment => {:horizontal => :center, :vertical => :center, :wrap_text => true}})
            end
            sheet["K5:AL7"].each do |cell|
                cell.style = wb.styles.add_style({bg_color:"fef2cb",:alignment => {:horizontal => :center, :vertical => :center, :wrap_text => true}})
            end

            sheet["G5:J7"].each do |cell|
                cell.style = wb.styles.add_style({bg_color:"93c47d",:alignment => {:horizontal => :center, :vertical => :center, :wrap_text => true}})
            end
            sheet["AM5:AP7"].each do |cell|
                cell.style = wb.styles.add_style({bg_color:"f7caac", :alignment => {:horizontal => :center, :vertical => :center, :wrap_text => true}})
            end

        end
        p.serialize "#{Rails.root}/tmp/generate_all.xlsx"
            send_file("#{Rails.root}/tmp/generate_all.xlsx", filename:"#{@disaster.name}-#{@disaster.date_of_occurence}.xlsx", type: "application/xlsx")

    end
    def barangay_group
        titles = [
            "Abella", "Bagumbayan Norte", "Bagumbayan Sur", "Balatas",
            "Calauag", "Cararayan", "Carolina", "Concepcion Grande",
            "Concepcion Pequeña", "Dayangdang", "Del Rosario", "Dinaga",
            "Igualdad","Lerma","Liboton", "Mabolo", "Pacol",
            "Panicuason", "Penafrancia", "Sabang", "San Felipe",
            "San Francisco", "San Isidro", "Sta. Cruz", "Tabuco",
            "Tinago", "Triangulo"
        ]
        return titles
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
    def getQuantity(x, y)
        xyValues = []
        EvacYearlyProfile.all.where(evac_id: x).where(year: y.year).each do |yp|
            AssignedYearlyEss.all.where(evac_profile_id: yp.id).each do |ye|
                xyValues.push(ye.quantity)
            end
        end
        return xyValues
    end
    def countServedFamily(evac_center, disaster, key )

        countFam = 0
        if key
           #evacuee = Evacuee.find_by_sql("SELECT DISTINCT(family_id) from evacuee where evac_id = #{evac_center} AND disaster_id = #{disaster} AND date_out = #{nil}")
            evacuee = Evacuee.all.where("evac_id = ?", evac_center).where(disaster_id: disaster).where(date_out: nil).distinct(:family_id)
        else
            #evacuee = Evacuee.find_by_sql("SELECT DISTINCT(family_id) from evacuee where evac_id = #{evac_center} AND disaster_id = #{disaster}")
            evacuee = Evacuee.all.where("evac_id = ?", evac_center).where(disaster_id: disaster).distinct(:family_id)
        end

        evacuee.each do |x|
            countFam = countFam + 1
        end
        return countFam
    end
    def countServedFamily4ps(evac_center, disaster, key )

        countFam = 0
        if key
            #evacuee = Evacuee.find_by_sql("SELECT DISTINCT(family_id) from evacuee where evac_id = #{evac_center} AND disaster_id = #{disaster} AND date_out = #{nil}")
            evacuee = Evacuee.all.where("evac_id = ?", evac_center).where(disaster_id: disaster).where(date_out: nil).distinct(:family_id)
        else
            #evacuee = Evacuee.find_by_sql("SELECT DISTINCT(family_id) from evacuee where evac_id = #{evac_center} AND disaster_id = #{disaster}")
            evacuee = Evacuee.all.where("evac_id = ?", evac_center).where(disaster_id: disaster).distinct(:family_id)
        end

        evacuee.each do |x|
            if(Family.find(x.family_id).is_4ps == true)
                countFam = countFam + 1
            end
        end
        return countFam
    end
    def countIndivEvacuated(evac_center,disaster,key)
        evacuees = Evacuee.all.where(disaster_id: disaster).where(evac_id: evac_center)
        if key
            member_ids = Array.new
            evacuees.each do |ec|
                EvacMember.all.where(evacuee_id: ec.id).where(status: "UNRELEASED").each do |em|
                       if !member_ids.include?(em.member_id)
                        member_ids.push(em.member_id)
                    end
                end
            end
            return member_ids.length
        else
            member_ids = Array.new
            evacuees.each do |ec|
                EvacMember.all.where(evacuee_id: ec.id).each do |em|
                       if !member_ids.include?(em.member_id)
                        member_ids.push(em.member_id)
                    end
                end
            end
            return member_ids.length
        end
    end
    def whitespacer(x)
        titles = []
        x.times { titles.push("")}
        return titles
    end
    def cumnow(x)
        titles = []
        x.times { titles.push("CUM", "NOW","CUM", "NOW")}
        return titles
    end
    def malefemale(x)
        titles = []
        x.times { titles.push("MALE","", "FEMALE","")}
        return titles
    end
    def age_groupT(k, gaps)
        titles = ["INFANT > 1y/o(0-11mos)", "TODDLERS 1-3 y/o", "PRESCHOOLERS 4-5 y/o", "SCHOOL AGE 6-12 y/o","TEENAGE 13-19 y/o", "ADULT 20-59 y/o", "SENIOR CITIZENS 60 and above"]
        newTitle = []
        if k
            titles.each do |title|
                newTitle.push(title)
                newTitle.concat(whitespacer(gaps))
            end
            return newTitle
        end
        return titles
    end
    def getReliefCost(center,disaster,k)
        priceValF = 0
        priceValN = 0
        GenRgAlloc.all.where("disaster_id = ? AND evac_id = ?", disaster , center).each do |rg|
            if ReliefGood.find(rg.rg_id).is_food == true
                priceValF +=rg.price
            elsif ReliefGood.find(rg.rg_id).is_food == false
                priceValN +=rg.price
            end
        end

        if k
            return priceValF
        else
            return priceValN
        end

    end
    
end
