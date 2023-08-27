class CampManagersController < ApplicationController
  before_action :set_camp_manager, only: %i[ show edit update destroy ]

  # GET /camp_managers or /camp_managers.json
  def index
    @camp_managers = CampManager.all
  end

  # GET /camp_managers/1 or /camp_managers/1.json
  def show
  end

  # GET /camp_managers/new
  def new
    @camp_manager = CampManager.new
  end

  # GET /camp_managers/1/edit
  def edit
  end

  # POST /camp_managers or /camp_managers.json
  def create
    @camp_manager = CampManager.new(camp_manager_params)

    respond_to do |format|
      if @camp_manager.save
        format.html { redirect_to camp_manager_url(@camp_manager), notice: "Camp manager was successfully created." }
        format.json { render :show, status: :created, location: @camp_manager }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @camp_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /camp_managers/1 or /camp_managers/1.json
  def update
    respond_to do |format|
      if @camp_manager.update(camp_manager_params)
        format.html { redirect_to camp_manager_url(@camp_manager), notice: "Camp manager was successfully updated." }
        format.json { render :show, status: :ok, location: @camp_manager }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @camp_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /camp_managers/1 or /camp_managers/1.json
  def destroy
    @camp_manager.destroy

    respond_to do |format|
      format.html { redirect_to camp_managers_url, notice: "Camp manager was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_camp_manager
      @camp_manager = CampManager.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def camp_manager_params
      params.require(:camp_manager).permit(:fname, :lname, :cnum, :address, :status)
    end
end
