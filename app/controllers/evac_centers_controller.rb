class EvacCentersController < ApplicationController
  before_action :set_evac_center, only: %i[ show edit update destroy ]

  # GET /evac_centers or /evac_centers.json
  def index
    @evac_centers = EvacCenter.all
  end

  # GET /evac_centers/1 or /evac_centers/1.json
  def show
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
      params.require(:evac_center).permit(:name, :isInside, :barangay)
    end
end
