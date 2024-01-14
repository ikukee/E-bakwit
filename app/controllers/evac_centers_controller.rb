class EvacCentersController < ApplicationController
  before_action :set_evac_center, only: %i[ show edit update destroy ]
  before_action :add_index_breadcrumb, only: [:show, :new, :edit, :evac_essentials_form, :evac_facilities_form]
  before_action :is_logged_in

  # GET /evac_centers or /evac_centers.json
  def index
    @evac_centers = EvacCenter.all.where(status: "ACTIVE").order(barangay: :asc)
    add_breadcrumb("Evacuation Centers")
  end

  # GET /evac_centers/1 or /evac_centers/1.json
  def show
    @evacYearlyProfile = EvacYearlyProfile.all.where(evac_id: params[:id]).first
    add_breadcrumb(@evac_center.name)

  end

  def search
    search_type = "name"
    @evac_centers = EvacCenter.where("lower(#{search_type}) LIKE ? ", "#{params[:search_value].downcase}%").where(status: "ACTIVE").order(name: :asc)
    respond_to do |format|
      if @evac_centers.length > 0
          format.turbo_stream{render turbo_stream: turbo_stream.update("evac_centers",partial: "evac_search_results", locals:{evac_centers:@evac_centers })}
      elsif @evac_centers.length <= 0
          format.turbo_stream{render turbo_stream: turbo_stream.update("evac_centers","<h2 style = 'text-align:center'>No Record/s found.</h2>")}
      end
    end

  end

  def archives
    @evac_centers = EvacCenter.all.where(status: "ARCHIVED").order(name: :asc)
    add_breadcrumb("Evacuation Centers", evac_centers_path)
    add_breadcrumb("Archived")
  end

  def add_profile
    @evac_center = EvacCenter.find(params[:id])
    @evac_yearly_profiles = EvacYearlyProfile.all.where(evac_id: params[:id])
    @evac_yearly_profile = EvacYearlyProfile.new
    @evac_yearly_profile.year = params[:date]
    key = false
    @evac_yearly_profiles.each do |eyp|
      if eyp.year == @evac_yearly_profile.year
        key = true
      end
    end

    if !key
      @evac_yearly_profile.evac_id = params[:id]
      @evac_yearly_profile.year = @evac_yearly_profile.year
      @evac_yearly_profile.save
    end
    redirect_to "/evac_centers/#{params[:id]}"
  end

  def display_yearly_profile
    @evac_center = EvacCenter.find(params[:id])
    @evacYearlyProfile = EvacYearlyProfile.find(params[:eid])
    @assignedYearlyVol = AssignedYearlyVol.all.where(evac_profile_id: @evacYearlyProfile.id)
    respond_to do |format|
      format.turbo_stream{render turbo_stream: turbo_stream.update("display_year_profile", partial:"display_year_profile",locals:{evac_center: @evac_center ,evac_yearly_profile: @evacYearlyProfile, assigned_yearly_vol: @assignedYearlyVol})}
    end

  end

  def view_disaster_evacuation
    @evac_center = EvacCenter.find(params[:evac_center])
    @disaster =Disaster.find(params[:disaster_id])
    respond_to do |format|
      format.turbo_stream{render turbo_stream: turbo_stream.update("display_disaster_evacuation", partial:"display_disaster_evacuation", locals:{evac_center: @evac_center, disaster:@disaster})}
    end

  end

  def archive_center
    @evac_center = EvacCenter.find(params[:id])
    @evac_center.update_attribute(:status, "ARCHIVED")
    redirect_to "/evac_centers/show/archives"
  end

  def unarchive_center
    @evac_center = EvacCenter.find(params[:id])
    @evac_center.update_attribute(:status, "ACTIVE")
    redirect_to "/evac_centers"
  end

  def add_volunteer
    assignedYearlyVol = AssignedYearlyVol.new
    assignedYearlyVol.volunteer_id = params[:volunteer_id]
    assignedYearlyVol.evac_profile_id = params[:evac_profile_id]
    evac_yearly_profile = EvacYearlyProfile.find(params[:evac_profile_id])
    evac_center = EvacCenter.find(evac_yearly_profile.evac_id)
    user = User.find(params[:volunteer_id])
    user.assigned = true
    user.currently_assigned = evac_center.id
    respond_to do |format|
      if assignedYearlyVol.valid?
        user.save
        assignedYearlyVol.save
        assignedYearlyVol= AssignedYearlyVol.all.where(evac_profile_id: evac_yearly_profile.id)
        format.turbo_stream{render turbo_stream: turbo_stream.update("display_year_profile", partial:"display_year_profile",locals:{evac_center: evac_center ,evac_yearly_profile: evac_yearly_profile, assigned_yearly_vol: assignedYearlyVol})}
      else
      end
        format.turbo_stream{render turbo_stream: turbo_stream.update("errmsg","Volunteer has already been assigned this year.")}
    end
  end

  def remove_volunteer
    assignedYearlyVol = AssignedYearlyVol.find(params[:id])
    evac_yearly_profile = EvacYearlyProfile.find(assignedYearlyVol.evac_profile_id)
    evac_center = EvacCenter.find(evac_yearly_profile.evac_id)
    user = User.find(assignedYearlyVol.volunteer_id)
    user.assigned = false
    user.currently_assigned = nil
    respond_to do |format|
      assignedYearlyVol.destroy
      user.save
      assignedYearlyVol = AssignedYearlyVol.all.where(evac_profile_id: evac_yearly_profile.id)
      format.turbo_stream{render turbo_stream: turbo_stream.update("display_year_profile", partial:"display_year_profile",locals:{evac_center: evac_center ,evac_yearly_profile: evac_yearly_profile, assigned_yearly_vol: assignedYearlyVol})}
    end
  end

  def add_campmanager
    evac_yearly_profile = EvacYearlyProfile.find(params[:evac_profile_id])
    evac_center = EvacCenter.find(evac_yearly_profile.evac_id)
    evac_yearly_profile.manager_id = params[:user_id]
    user = User.find(params[:user_id])
    user.assigned = true
    user.currently_assigned = evac_center.id
    respond_to do |format|
      if evac_yearly_profile.valid?
        user.save
        evac_yearly_profile.save
        assignedYearlyVol= AssignedYearlyVol.all.where(evac_profile_id: evac_yearly_profile.id)
        format.turbo_stream{render turbo_stream: turbo_stream.update("display_year_profile", partial:"display_year_profile",locals:{evac_center: evac_center ,evac_yearly_profile: evac_yearly_profile, assigned_yearly_vol: assignedYearlyVol})}
      else
        format.turbo_stream{render turbo_stream: turbo_stream.update("camp_errmsg", "Camp Manager has already been assigned this year.")}
      end

    end
  end

  def remove_campmanager
    evac_yearly_profile = EvacYearlyProfile.find(params[:id])
    evac_center = EvacCenter.find(evac_yearly_profile.evac_id)
    user = User.find(evac_yearly_profile.manager_id)
    evac_yearly_profile.manager_id = nil
    user.assigned = false
    user.currently_assigned = nil
    respond_to do |format|
      evac_yearly_profile.save
      user.save
      assignedYearlyVol = AssignedYearlyVol.all.where(evac_profile_id: evac_yearly_profile.id)
      format.turbo_stream{render turbo_stream: turbo_stream.update("display_year_profile", partial:"display_year_profile",locals:{evac_center: evac_center ,evac_yearly_profile: evac_yearly_profile, assigned_yearly_vol: assignedYearlyVol})}
    end
  end
  # GET /evac_centers/new
  def new
    @evac_center = EvacCenter.new
    add_breadcrumb('New')
  end

  # GET /evac_centers/1/edit
  def edit
    add_breadcrumb(@evac_center.name, evac_center_path(@evac_center))
    add_breadcrumb('Edit')
  end

  # POST /evac_centers or /evac_centers.json
  def create
    @evac_center = EvacCenter.new(evac_center_params)
    @evac_center.status = "ACTIVE"
    respond_to do |format|
      if @evac_center.save
        @evacYearlyProfile = EvacYearlyProfile.new
        @evacYearlyProfile.evac_id = @evac_center.id
        @evacYearlyProfile.year = Date.today().year
        @evacYearlyProfile.save
        format.html { redirect_to evac_center_url(@evac_center), notice: "Evac center was successfully created." }
        format.json { render :show, status: :created, location: @evac_center }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @evac_center.errors, status: :unprocessable_entity }
      end
    end



  end

  # PATCH/PUT /evac_centers/1 or /evac_centers/1.json
  def update
    respond_to do |format|
      if @evac_center.update(evac_center_params)
        format.html { redirect_to evac_center_url(@evac_center), notice: "Evac center was successfully updated." }
        format.json { render :show, status: :ok, location: @evac_center }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @evac_center.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /evac_centers/1 or /evac_centers/1.json
  def destroy
    @evacYearlyProfile = EvacYearlyProfile.all.where(evac_id: @evac_center.id)
    @evacYearlyProfile.each do |ec|
      @assignedYearlyVol = AssignedYearlyVol.all.where(evac_profile_id: ec.id)
      @assignedYearlyEss = AssignedYearlyEss.all.where(evac_profile_id: ec.id)
      @assignedYearlyVol.each do |av|
        av.destroy
      end
      @assignedYearlyEss.each do |ae|
        ae.destroy
      end
      ec.destroy
    end
    @evac_center.destroy

    respond_to do |format|
      format.html { redirect_to evac_centers_url, notice: "Evac center was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def evac_facilities_form
    @evac_center = EvacCenter.find(params[:evac_id])
    @evac_yearly_profile =EvacYearlyProfile.find(params[:profile_id])
    add_breadcrumb(@evac_center.name, evac_center_path(@evac_center))
    add_breadcrumb('Facilities for Year ' + @evac_yearly_profile.year.to_s)
    @assigned_yearly_esses = AssignedYearlyEss.all.where(evac_profile_id: params[:profile_id])
    @new_yearly_ess = AssignedYearlyEss.new
    @page = params.fetch(:page, 0).to_i
    if  @page < 0
        @page = 0
    end
    @assigned_yearly_esses_count = @assigned_yearly_esses.length
    @assigned_yearly_esses_count_per_page = 10
    @assigned_yearly_esses = AssignedYearlyEss.offset(@page * @assigned_yearly_esses_count_per_page).limit(@assigned_yearly_esses_count_per_page).all.where(evac_profile_id: params[:profile_id])

  end

  def add_facility
    @evac_center = EvacCenter.find(params[:assigned_yearly_ess][:evac_id])
    @evac_yearly_profile =EvacYearlyProfile.find(params[:assigned_yearly_ess][:profile_id])
    @assigned_yearly_ess = AssignedYearlyEss.new
    @assigned_yearly_ess.ess_id = params[:assigned_yearly_ess][:ess_id]
    @assigned_yearly_ess.evac_profile_id = params[:assigned_yearly_ess][:profile_id]
    @assigned_yearly_ess.quantity = params[:assigned_yearly_ess][:quantity]
    @assigned_yearly_ess.status = params[:assigned_yearly_ess][:status]

    respond_to do |format|
      if @assigned_yearly_ess.valid?
        @assigned_yearly_ess.save
        format.html{redirect_to "/evac_facilities_form/#{@evac_center.id}/#{@evac_yearly_profile.id}"}
      else
        format.turbo_stream{render turbo_stream: turbo_stream.update("form_area",partial: "evac_facilities_form",locals:{evac_center: @evac_center, evac_yearly_profile: @evac_yearly_profile, assigned_yearly_ess: @assigned_yearly_ess})}
      end
    end
  end

  def evac_essentials_form
    @evac_center = EvacCenter.find(params[:evac_id])
    @evac_yearly_profile =EvacYearlyProfile.find(params[:profile_id])
    add_breadcrumb(@evac_center.name, evac_center_path(@evac_center))
    add_breadcrumb('Essentials for Year ' + @evac_yearly_profile.year.to_s)
    @assigned_yearly_esses = AssignedYearlyEss.all.where(evac_profile_id: params[:profile_id])
    @new_yearly_ess = AssignedYearlyEss.new
    @page = params.fetch(:page, 0).to_i
    if  @page < 0
        @page = 0
    end
    @assigned_yearly_esses_count = @assigned_yearly_esses.length
    @assigned_yearly_esses_count_per_page = 10
    @assigned_yearly_esses = AssignedYearlyEss.offset(@page * @assigned_yearly_esses_count_per_page).limit(@assigned_yearly_esses_count_per_page).all.where(evac_profile_id: params[:profile_id])
  end

  def add_item
    @evac_center = EvacCenter.find(params[:assigned_yearly_ess][:evac_id])
    @evac_yearly_profile =EvacYearlyProfile.find(params[:assigned_yearly_ess][:profile_id])
    @assigned_yearly_ess = AssignedYearlyEss.new
    @assigned_yearly_ess.ess_id = params[:assigned_yearly_ess][:ess_id]
    @assigned_yearly_ess.evac_profile_id = params[:assigned_yearly_ess][:profile_id]
    @assigned_yearly_ess.quantity = params[:assigned_yearly_ess][:quantity]
    @assigned_yearly_ess.status = params[:assigned_yearly_ess][:status]
    respond_to do |format|
      if @assigned_yearly_ess.valid?
         @assigned_yearly_ess.save
         @assigned_yearly_esses = AssignedYearlyEss.all.where(evac_profile_id: @evac_yearly_profile.id)
        format.turbo_stream{render turbo_stream: turbo_stream.update("display_area",partial: "display_evac_essential",locals:{evac_center: @evac_center, evac_yearly_profile: @evac_yearly_profile, assigned_yearly_esses: @assigned_yearly_esses})}
      else
        format.turbo_stream{render turbo_stream: turbo_stream.update("form_area",partial: "evac_essentials_form",locals:{evac_center: @evac_center, evac_yearly_profile: @evac_yearly_profile, assigned_yearly_ess: @assigned_yearly_ess})}
      end
    end
  end

  def destroy_essential
    assigned_yearly_ess = AssignedYearlyEss.find(params[:id])
    evac_yearly_profile = EvacYearlyProfile.find(assigned_yearly_ess.evac_profile_id)
    evac_center = evac_yearly_profile.evac_id
    essential = EvacuationEssential.find(assigned_yearly_ess.ess_id).ess_type
    assigned_yearly_ess.destroy
      respond_to do |format|
        if essential == "FACILITY"
          redirect_to "/evac_facilities_form/#{evac_center}/#{evac_yearly_profile.id}"
        else
          redirect_to "/evac_essentials_form/#{evac_center}/#{evac_yearly_profile.id}"
        end

        
      end
  end

  def add_index_breadcrumb
    add_breadcrumb('Evacuation Centers', evac_centers_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evac_center
      @evac_center = EvacCenter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def evac_center_params
      params.require(:evac_center).permit(:name, :isInside, :barangay, :capacity)
    end
end
