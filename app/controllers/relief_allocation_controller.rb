class ReliefAllocationController < ApplicationController
    before_action :add_index_breadcrumb, only: [:storage, :your_request, :configuration]


    def relief_request
        add_breadcrumb('Pending Requests')
        @requests = ReliefRequest.all.where(status: "PENDING").order(:date_of_request)
        @page = params.fetch(:page, 0).to_i
        if  @page < 0 
            @page = 0
        end
        @requests_count = @requests.length
        @requests_count_per_page = 5
        @requests = ReliefRequest.offset(@page * @requests_count_per_page).limit(@requests_count_per_page).where(status: "PENDING").order(date_of_request: :desc)
       
    end
    def accepted_request
        add_breadcrumb('Accepted Requests')
        @requests = ReliefRequest.all.where(status: "ACCEPTED").order(:date_of_request)
        @page = params.fetch(:page, 0).to_i
        if  @page < 0 
            @page = 0
        end
        @requests_count = @requests.length
        @requests_count_per_page = 5
        @requests = ReliefRequest.offset(@page * @requests_count_per_page).limit(@requests_count_per_page).where(status: "ACCEPTED").order(date_of_request: :desc)
    end

    def dispatched_request
        add_breadcrumb('Dispatched Requests')
        @requests = ReliefRequest.all.where("status == 'DISPATCHED' OR status == 'RECEIVED'").order(:date_of_request)
        @page = params.fetch(:page, 0).to_i
        if  @page < 0 
            @page = 0
        end
        @requests_count = @requests.length
        @requests_count_per_page = 5
        @requests = ReliefRequest.offset(@page * @requests_count_per_page).limit(@requests_count_per_page).where("status == 'RECEIVED' OR status == 'DISPATCHED' ").order(date_of_request: :desc)
    end

    def send_request
        relief_request =ReliefRequest.new
        relief_request.volunteer_id = params[:volunteer_id]
        relief_request.evac_id = params[:evac_id]
        relief_request.disaster_id =params[:disaster_id]
        relief_request.date_of_request = Date.today
        relief_request.status = "PENDING"
        relief_request.message = params[:message]
        respond_to do |format|
            if relief_request.save
                format.html{redirect_to "/relief_allocation/#{params[:evac_id]}/#{params[:disaster_id]}"}
            end
        end
    end

    def approve_request
        relief_request= ReliefRequest.find(params[:id])
        relief_request.update_attribute(:status, "ACCEPTED")
        redirect_to "/dispatch/request/#{relief_request.id}"
    end

    def view_request
        relief_request =ReliefRequest.find(params[:id])
        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("view_request",partial: "view_request",locals:{request: relief_request})}
        end
    end

    def allocation
        @relief_request =ReliefRequest.find(params[:id])
        @dispatched_rg = DispatchedRg.all.where(request_id: @relief_request.id)
        @evac_center = EvacCenter.find_by(id: @relief_request.evac_id)
        add_breadcrumb("Evacuation Centers", evac_centers_path)
        add_breadcrumb(@evac_center.name, evac_center_path(@evac_center))
        add_breadcrumb("Relief Goods Allocation", "/evac_centers/non_distributed_rg/" + @relief_request.evac_id.to_s + "/" + @relief_request.disaster_id.to_s)
        add_breadcrumb("Allocated Relief Goods")
    end

    def dispatch_request
        @relief_request =ReliefRequest.find(params[:id])
        @relief_request.update_attribute(:date_of_dispatch, Date.today)
        @relief_request.update_attribute(:status, "DISPATCHED")
        redirect_to "/relief_good/dispatched_requests"
    end

    def allocate_rg
        relief_request = ReliefRequest.find(params[:dispatched_rg][:request_id])
        dispatched_rg = DispatchedRg.all.where(request_id: relief_request.id)

        key = false
        dispatched_rg.each do |gen|
            if gen.rg_id == params[:dispatched_rg][:rg_id].to_i
                dispatched_rg = gen
                key = true
                break
            end
        end
        if !key
            dispatched_rg = DispatchedRg.new
            dispatched_rg.request_id = relief_request.id
            dispatched_rg.rg_id = params[:dispatched_rg][:rg_id]
        end

        dispatched_rg.quantity = params[:dispatched_rg][:quantity]
        if ReliefGood.where(id: dispatched_rg.rg_id).length > 0 
            dispatched_rg.name = ReliefGood.find(dispatched_rg.rg_id).name
        end
        respond_to do |format|
            if dispatched_rg.save
                dispatched_rg = DispatchedRg.all.where(request_id: relief_request.id)
                format.turbo_stream{render turbo_stream: turbo_stream.update("show_rg_area",partial:"show_allocated_rg",locals:{dispatched_rg: dispatched_rg, relief_request:relief_request})}
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("rg_form_area",partial: "add_rg",locals:{relief_request: relief_request, dispatched_rg:dispatched_rg})}
            end

        end
    end

    def edit_rg
        dispatched_rg = DispatchedRg.find(params[:rg_id])
        relief_request = ReliefRequest.find(params[:request_id])
        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("rg_form_area",partial: "add_rg",locals:{relief_request: relief_request, dispatched_rg:dispatched_rg})}
        end

    end

    def your_request
        @disaster_id = params[:disaster_id]
        @evac_id = params[:evac_id]
        @requests = ReliefRequest.all.where(disaster_id: @disaster_id).where(evac_id:@evac_id)
        @page = params.fetch(:page, 0).to_i
        if  @page < 0 
            @page = 0
        end
        @requests_count = @requests.length
        @requests_count_per_page = 5
        @requests = ReliefRequest.offset(@page * @requests_count_per_page).limit(@requests_count_per_page).where(disaster_id: @disaster_id).where(evac_id:@evac_id).order(date_of_request: :desc)

    end

    def receive_request
        @relief_request = ReliefRequest.find(params[:id])
      
        evac_id = @relief_request.evac_id
        disaster_id = @relief_request.disaster_id
        @dispatched_rgs = DispatchedRg.all.where(request_id: @relief_request.id)
        @dispatched_rgs.each do |drg|
            gen_rg_alloc = GenRgAlloc.all.where(disaster_id: disaster_id).where(evac_id:  evac_id).where(rg_id: drg.rg_id)
            key = false
            if gen_rg_alloc.length < 1
                key = true
                gen_rg_alloc = GenRgAlloc.new
               
                gen_rg_alloc.rg_id = drg.rg_id
                gen_rg_alloc.disaster_id = disaster_id
                gen_rg_alloc.evac_id = evac_id
                gen_rg_alloc.name = drg.name
                gen_rg_alloc.quantity = drg.quantity
                gen_rg_alloc.price = drg.quantity * ReliefGood.find(drg.rg_id).price
            else
                gen_rg_alloc = gen_rg_alloc.first
                gen_rg_alloc.quantity = drg.quantity + gen_rg_alloc.quantity
                gen_rg_alloc.price = gen_rg_alloc.price + (drg.quantity * ReliefGood.find(drg.rg_id).price)
            end
            gen_rg_alloc.save

            if key
                criteria = RgCriterium.new
                criteria.gen_rg_alloc_id = gen_rg_alloc.id
                criteria.criteria = 1
                criteria.save
            end
          
        end
        @relief_request.update_attribute(:status, "RECEIVED")
        redirect_to "/relief_allocation/#{@relief_request.evac_id}/#{@relief_request.disaster_id}"
    end

    def configuration
        @disaster_id = params[:disaster_id]
        @evac_id = params[:evac_id]
        @gen_rg_allocs = GenRgAlloc.all.where(disaster_id: @disaster_id).where(evac_id: @evac_id).order(:name)
    end

    def storage
        @disaster_id = params[:disaster_id]
        @evac_id = params[:evac_id]
        @relief_goods = GenRgAlloc.all.where(disaster_id: @disaster_id).where(evac_id: @evac_id)
        @page = params.fetch(:page, 0).to_i
        if  @page < 0 
            @page = 0
        end
        @relief_goods_count = @relief_goods.length
        @relief_goods_count_per_page = 10
        @relief_goods = GenRgAlloc.offset(@page * @relief_goods_count_per_page).limit(@relief_goods_count_per_page).where(disaster_id: @disaster_id).where(evac_id: @evac_id).order(:name)
    end

    def sort_by
        search_type = params[:search_type]
        @disaster_id = params[:disaster_id]
        @evac_id = params[:evac_id]
        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("type_output", partial: "search_field",locals:{search_type: search_type, disaster_id: @disaster_id, evac_id: @evac_id})}
        end

    end

    def sort_by_type
        search_type = params[:search_type]
        @disaster_id = params[:disaster_id]
        @evac_id = params[:evac_id]
        @relief_goods = GenRgAlloc.all.where(disaster_id: @disaster_id).where(evac_id: @evac_id)
        @page = params.fetch(:page, 0).to_i
        if  @page < 0 
            @page = 0
        end
        @relief_goods_count = @relief_goods.length
        @relief_goods_count_per_page = 10
        @relief_goods = GenRgAlloc.offset(@page * @relief_goods_count_per_page).limit(@relief_goods_count_per_page).where(disaster_id: @disaster_id).where(evac_id: @evac_id).order(:name)
        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("storage", partial: "food_storage",locals:{relief_goods: @relief_goods, search_type: search_type})}
        end
    end

    def sort_by_search
        search_type = params[:search_type]
        @disaster_id = params[:disaster_id]
        @evac_id = params[:evac_id]
        @relief_goods = GenRgAlloc.where("name LIKE ? ", "#{search_type}%").where(disaster_id: @disaster_id).where(evac_id: @evac_id)
        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("storage", partial: "food_storage",locals:{relief_goods: @relief_goods, search_type: nil})}
        end
    end

    def show_configurations
        search_type = params[:search_type]
        @disaster_id = params[:disaster_id]
        @evac_id = params[:evac_id]
        @gen_rg_allocs = GenRgAlloc.all.where(disaster_id: @disaster_id).where(evac_id: @evac_id).order(:name)
        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("display_area",partial: "display_configuration",locals:{gen_rg_allocs: @gen_rg_allocs, search_type: search_type})}
        end
    end

    def save_configuration 
        rg_criterium = RgCriterium.find(params[:id])
        gen_rg_alloc = GenRgAlloc.find(rg_criterium.gen_rg_alloc_id)
        if ReliefGood.find(gen_rg_alloc.rg_id).is_food == true
            search_type = "FOOD"
        else
            search_type = "NON-FOOD"
        end
        gen_rg_alloc = GenRgAlloc.all.where(disaster_id: gen_rg_alloc.disaster_id).where(evac_id: gen_rg_alloc.evac_id)
        rg_criterium.update_attribute(:criteria, params[:criteria])
        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("display_area",partial: "display_configuration",locals:{gen_rg_allocs: gen_rg_alloc, search_type: search_type})}
        end
    end

    def distributed_rg
        @disaster_id = params[:disaster_id]
        @evac_id = params[:evac_id]
        @gen_rg_allocs = GenRgAlloc.all.where(disaster_id: @disaster_id).where(evac_id: @evac_id)

        @evacuees= Evacuee.all.where(disaster_id: @disaster_id).where(evac_id:@evac_id).where(relief_good_status: "RECEIVED")
        @page = params.fetch(:page, 0).to_i
        if  @page < 0 
            @page = 0
        end
        @evacuees_count = @evacuees.length
        @evacuees_count_per_page = 5
        @evacuees = Evacuee.offset(@page * @evacuees_count_per_page).limit(@evacuees_count_per_page).order(:family_name).where(disaster_id: @disaster_id).where(evac_id:@evac_id).where(relief_good_status: "RECEIVED")
    
        @evac_center = EvacCenter.find_by(id: @evac_id)
        add_breadcrumb("Evacuation Centers", evac_centers_path)
        add_breadcrumb(@evac_center.name, evac_center_path(@evac_center))
        add_breadcrumb("Relief Goods Allocation")
    end

    def non_distributed_rg
        @disaster_id = params[:disaster_id]
        @evac_id = params[:evac_id]
        @gen_rg_allocs = GenRgAlloc.all.where(disaster_id: @disaster_id).where(evac_id: @evac_id)

        @evacuees= Evacuee.all.where(disaster_id: @disaster_id).where(evac_id:@evac_id).where(relief_good_status: "RECEIVED")
        @page = params.fetch(:page, 0).to_i
        if  @page < 0 
            @page = 0
        end
        @evacuees_count = @evacuees.length
        @evacuees_count_per_page = 5
        @evacuees = Evacuee.offset(@page * @evacuees_count_per_page).limit(@evacuees_count_per_page).order(:family_name).where(disaster_id: @disaster_id).where(evac_id:@evac_id).where(relief_good_status: nil).where(date_out: nil)
        
        @evac_center = EvacCenter.find_by(id: @evac_id)
        add_breadcrumb("Evacuation Centers", evac_centers_path)
        add_breadcrumb(@evac_center.name, evac_center_path(@evac_center))
        add_breadcrumb("Relief Goods Allocation")
    end

    def view_evac_members
        @method = params[:method]
        @evacuee = Evacuee.find(params[:id])
        @members = EvacMember.all.where(evacuee_id: @evacuee.id)
        @gen_rg_allocs = GenRgAlloc.all.where(disaster_id: @evacuee.disaster_id).where(evac_id: @evacuee.evac_id)
        @evac_center = EvacCenter.find_by(id: @evacuee.evac_id)
        add_breadcrumb("Evacuation Centers", evac_centers_path)
        add_breadcrumb(@evac_center.name, evac_center_path(@evac_center))
        add_breadcrumb("Relief Goods Allocation", "/evac_centers/non_distributed_rg/" + @evac_center.id.to_s + "/" + @evacuee.disaster_id.to_s)
        add_breadcrumb(@evacuee.family_name)
    end

    def distribute_goods
        evacuee = Evacuee.find(params[:id])
        gen_rg_allocs = GenRgAlloc.all.where(disaster_id: evacuee.disaster_id).where(evac_id: evacuee.evac_id)
        counter = params[:counter]
        x = 0
        rg = ReliefGoodToEvacuee.all.where(evacuee_id: evacuee.id)
        batch = 0

        if rg.length < 1 #checks if assigned rg exists
            batch = 1
        else #increments batch by finding the last batch
           batch = rg.last.batch.to_i + 1
        end

        key = false
        while x < counter.to_i #checks if there were relief goods included
            include = "include" + x.to_s
            if params[include].to_i == 1
                key = true
                break
            end
            x= x + 1
        end

        if key
            x = 0
            while x < counter.to_i
                include = "include"+ x.to_s
                gen_id = "gen_id"+x.to_s
                quantity = "quantity"+x.to_s
                criterium = RgCriterium.find_by(gen_rg_alloc_id: params[gen_id])
           
                if params[include].to_i == 1
                    assignedRg = ReliefGoodToEvacuee.new
                    assignedRg.evacuee_id = evacuee.id
                    assignedRg.criterium_id = criterium.id
                    assignedRg.gen_id = params[gen_id]
                    assignedRg.quantity = params[quantity]
                    assignedRg.batch = batch
                    assignedRg.save
                    gen = GenRgAlloc.find(params[gen_id])
                    if gen.quantity.to_f - assignedRg.quantity.to_f < 1
                        gen.update_attribute(:quantity, 0)
                    else 
                        gen.update_attribute(:quantity, gen.quantity.to_f - assignedRg.quantity.to_f)
                    end
                end
                x = x + 1 
            end
            evacuee.update_attribute(:relief_good_status, "RECEIVED")
            redirect_to "/view/evacuee/members/#{evacuee.id}/allotted"
        else

            respond_to do |format|
                format.turbo_stream{render turbo_stream: turbo_stream.update("err_msg","Cannot Distribute nothing. At least one relief good must be included.")}
            end
        end

        
        
    end

    def view_allocated_rgs
        evacuee = Evacuee.find(params[:evacuee_id])
        batch = params[:batch]
        if batch != nil
            allocated_rgs = ReliefGoodToEvacuee.all.where(evacuee_id: evacuee.id).where(batch: batch)
        end
        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("display_batch",partial: "display_allocated_rg", locals:{allocated_rgs: allocated_rgs})}
        end
    end

    def search_evacuees
        search_value =params[:search_value]
        @evacuees = Evacuee.where("family_name Like ? ","#{search_value}%").where(disaster_id: params[:disaster_id]).where(evac_id: params[:evac_id]).where(relief_good_status: params[:search_type])
        @gen_rg_allocs = GenRgAlloc.all.where(disaster_id:params[:disaster_id]).where(evac_id: params[:evac_id])
        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("search_results", partial:"search_results",locals:{evacuees: @evacuees, gen_rg_allocs: @gen_rg_allocs})}
        end
    end

    def add_index_breadcrumb
        @evac_center = EvacCenter.find_by(id: params[:evac_id])
        add_breadcrumb("Evacuation Centers", evac_centers_path)
        add_breadcrumb(@evac_center.name, evac_center_path(@evac_center))
        add_breadcrumb("Relief Goods Configuration")
    end

  

    

    
end
