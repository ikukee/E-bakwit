class EvacCentersController < ApplicationController
  before_action :set_evac_center, only: %i[ show edit update destroy ]

  # GET /evac_centers or /evac_centers.json
  def index
    @evac_centers = EvacCenter.all.order(name: :asc)
  end

  # GET /evac_centers/1 or /evac_centers/1.json
  def show
    @evacYearlyProfile = EvacYearlyProfile.all.where(evac_id: params[:id]).last
    
  end

  def search
    search_type = "name"
    @evac_centers = EvacCenter.where("#{search_type} LIKE ? ", "#{params[:search_value]}%").order(name: :asc)
    respond_to do |format|
      if @evac_centers.length > 0
          format.turbo_stream{render turbo_stream: turbo_stream.update("evac_centers",partial: "evac_search_results", locals:{evac_centers:@evac_centers })}
      elsif @evac_centers.length <= 0
          format.turbo_stream{render turbo_stream: turbo_stream.update("evac_centers","<h2 style = 'text-align:center'>No Record/s found.</h2>")}
      end
    end

  end

  def display_yearly_profile
    @evac_center = EvacCenter.find(params[:id])
    @evacYearlyProfile = EvacYearlyProfile.find(params[:eid])
    @assignedYearlyVol = AssignedYearlyVol.all.where(evac_profile_id: @evacYearlyProfile.id)
    respond_to do |format|
      format.turbo_stream{render turbo_stream: turbo_stream.update("display_year_profile", partial:"display_year_profile",locals:{evac_center: @evac_center ,evac_yearly_profile: @evacYearlyProfile, assigned_yearly_vol: @assignedYearlyVol})}
    end

  end

  def add_volunteer
    assignedYearlyVol = AssignedYearlyVol.new
    assignedYearlyVol.volunteer_id = params[:user_id]
    assignedYearlyVol.evac_profile_id = params[:evac_profile_id]
    evac_yearly_profile = EvacYearlyProfile.find(params[:evac_profile_id])
    evac_center = EvacCenter.find(evac_yearly_profile.evac_id)
    user = User.find(params[:user_id])
    user.assigned = true
    user.currently_assigned = evac_center.id
    respond_to do |format|
      user.save
      assignedYearlyVol.save
      assignedYearlyVol= AssignedYearlyVol.all.where(evac_profile_id: evac_yearly_profile.id)
      format.turbo_stream{render turbo_stream: turbo_stream.update("display_year_profile", partial:"display_year_profile",locals:{evac_center: evac_center ,evac_yearly_profile: evac_yearly_profile, assigned_yearly_vol: assignedYearlyVol})}
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
      user.save
      evac_yearly_profile.save
      assignedYearlyVol= AssignedYearlyVol.all.where(evac_profile_id: evac_yearly_profile.id)
      format.turbo_stream{render turbo_stream: turbo_stream.update("display_year_profile", partial:"display_year_profile",locals:{evac_center: evac_center ,evac_yearly_profile: evac_yearly_profile, assigned_yearly_vol: assignedYearlyVol})}
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
  end

  # GET /evac_centers/1/edit
  def edit
  end

  # POST /evac_centers or /evac_centers.json
  def create
    @evac_center = EvacCenter.new(evac_center_params)
    
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
