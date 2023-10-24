class FamiliesController < ApplicationController
  before_action :set_family, only: %i[ show edit update destroy ]

  def search
    search_type = params[:search_type]
    if search_type == "BARANGAY"
      search_type = "barangay"
    else
      search_type = "name"
    end
    @families = Family.where("#{search_type} LIKE ? ", "#{params[:search_value]}%").order(:name)
    respond_to do |format|
      if @families.length > 0
          format.turbo_stream{render turbo_stream: turbo_stream.update("families",partial: "search_results", locals:{families:@families })}
      elsif @families.length <= 0
          format.turbo_stream{render turbo_stream: turbo_stream.update("families","<h2 style = 'text-align:center'>No Record/s found.</h2>")}
      end
    end
  end
  # GET /families or /families.json
  def index
    @families = Family.all
    @page = params.fetch(:page, 0).to_i
    if  @page < 0 
        @page = 0
    end
    @families_count = @families.length
    @families_count_per_page = 5
    @families = Family.offset(@page * @families_count_per_page).limit(@families_count_per_page).order(:name)
  end

  # GET /families/1 or /families/1.json
  def show
  end

  # GET /families/new
  def new
    @family = Family.new
  end

  # GET /families/1/edit
  def edit
  end

  # POST /families or /families.json
  def create
    @family = Family.new(family_params)
    @family.is_evacuated = false
    @family.name = @family.name.upcase
    @family.streetName = @family.streetName.upcase
    @family.barangay = @family.barangay.upcase
    respond_to do |format|
      if @family.save
        format.html { redirect_to family_url(@family), notice: "Family was successfully created." }
        format.json { render :show, status: :created, location: @family }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @family.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /families/1 or /families/1.json
  def update   
    params[:family][:name] = params[:family][:name].upcase
    params[:family][:streetName] = params[:family][:streetName].upcase
    params[:family][:barangay] = params[:family][:barangay].upcase
    respond_to do |format|
      if @family.update(family_params)
        family_members = FamilyMember.all.where(family_id: @family.id)
        family_members.each do |member|
          member.lname = @family.name
          member.save
        end
        format.html { redirect_to family_url(@family), notice: "Family was successfully updated." }
        format.json { render :show, status: :ok, location: @family }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @family.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_member
    family = Family.find(params[:family_member][:id])
    family_member = FamilyMember.new
    family_member.family_id = family.id
    family_member.fname = params[:family_member][:fname].upcase
    family_member.lname = params[:family_member][:lname].upcase
    family_member.age = params[:family_member][:age]
    family_member.sex = params[:family_member][:sex]
    family_member.is_pregnant = params[:family_member][:is_pregnant]
    family_member.is_parent = params[:family_member][:is_parent]
    family_member.is_pwd = params[:family_member][:is_pwd]
    family_member.is_breastfeeding = params[:family_member][:is_breastfeeding]
    respond_to do |format|
      if family_member.valid?
        family_member.save
        format.html{redirect_to "/families/#{family.id}"}
      else
        format.turbo_stream{render turbo_stream: turbo_stream.update("member_form_area",partial: "add_member", locals:{family: family, family_member: family_member })}
      end
    end
  end

  def edit_member
    family_member = FamilyMember.find(params[:id])
    family = Family.find(family_member.family_id)
    respond_to do |format|
      format.turbo_stream{render turbo_stream: turbo_stream.update("member_form_area", partial:"add_member", locals: {family: family, family_member: family_member})}
    end
  end
  def update_member
    family = Family.find(params[:family_member][:id])
    family_member = FamilyMember.find(params[:family_member][:member_id])
    family_member.family_id = family.id
    family_member.fname = params[:family_member][:fname].upcase
    family_member.lname = params[:family_member][:lname].upcase
    family_member.age = params[:family_member][:age]
    family_member.sex = params[:family_member][:sex]
    family_member.is_pregnant = params[:family_member][:is_pregnant]
    family_member.is_parent = params[:family_member][:is_parent]
    family_member.is_pwd = params[:family_member][:is_pwd]
    family_member.is_breastfeeding = params[:family_member][:is_breastfeeding]
    respond_to do |format|
      if family_member.valid?
        family_member.save
        format.html{redirect_to "/families/#{family.id}"}
      else
        format.turbo_stream{render turbo_stream: turbo_stream.update("member_form_area",partial: "add_member", locals:{family: family, family_member: family_member })}
      end
    end

  end

  # DELETE /families/1 or /families/1.json
  def destroy
    @family_members = FamilyMember.all.where(family_id: @family.id)
    @family_members.each do |member|
      member.destroy
    end
    @family.destroy
    
    respond_to do |format|
      format.html { redirect_to families_url, notice: "Family was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def destroy_member
    family_member = FamilyMember.find(params[:id])
    id = family_member.family_id
    family_member.destroy
    redirect_to "/families/#{id}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_family
      @family = Family.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def family_params
      params.require(:family).permit(:name, :houseNum, :barangay, :is_4ps, :zone, :streetName, :is_evacuated)

    end
end
