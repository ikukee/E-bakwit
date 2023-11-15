class EvacuationEssentialsController < ApplicationController
  before_action :set_evacuation_essential, only: %i[ show edit update destroy ]
  before_action :add_index_breadcrumb, only: [:show, :new, :edit]

  def search
    search_type = params[:search_type]
    if search_type == "TYPE"
      search_type = "ess_type"
    else
      search_type = "name"
    end
    @evacuation_essentials = EvacuationEssential.where("#{search_type} LIKE ? ", "#{params[:search_value]}%").order(:name)
    respond_to do |format|
      if @evacuation_essentials.length > 0
          format.turbo_stream{render turbo_stream: turbo_stream.update("evacuation_essentials",partial: "search_results", locals:{evacuation_essentials:@evacuation_essentials })}
      elsif @evacuation_essentials.length <= 0
          format.turbo_stream{render turbo_stream: turbo_stream.update("evacuation_essentials","<h2 style = 'text-align:center'>No Record/s found.</h2>")}
      end
    end
  end
  # GET /evacuation_essentials or /evacuation_essentials.json
  def index
    add_breadcrumb('Evacuation Essentials')
    @evacuation_essentials = EvacuationEssential.all

    @page = params.fetch(:page, 0).to_i
    if  @page < 0 
        @page = 0
    end
    @evacuation_essentials_count = @evacuation_essentials.length
    @evacuation_essentials_per_page = 5
    @evacuation_essentials = EvacuationEssential.offset(@page * @evacuation_essentials_per_page).limit(@evacuation_essentials_per_page).order(:name)
  end

  # GET /evacuation_essentials/1 or /evacuation_essentials/1.json
  def show
  end

  # GET /evacuation_essentials/new
  def new
    @evacuation_essential = EvacuationEssential.new
    add_breadcrumb('Add Essential')
  end

  # GET /evacuation_essentials/1/edit
  def edit
    add_breadcrumb(@evacuation_essential.name.titleize)
  end

  # POST /evacuation_essentials or /evacuation_essentials.json
  def create
    @evacuation_essential = EvacuationEssential.new(evacuation_essential_params)
    @evacuation_essential.name = @evacuation_essential.name.upcase
    respond_to do |format|
      if @evacuation_essential.save
        format.html { redirect_to "/evacuation_essentials", notice: "Evacuation essential was successfully created." }
        format.json { render :show, status: :created, location: @evacuation_essential }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @evacuation_essential.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /evacuation_essentials/1 or /evacuation_essentials/1.json
  def update
    
    respond_to do |format|
      params[:evacuation_essential][:name] = params[:evacuation_essential][:name].upcase
      if @evacuation_essential.update(evacuation_essential_params)
        format.html { redirect_to "/evacuation_essentials", notice: "Evacuation essential was successfully updated." }
        format.json { render :show, status: :ok, location: @evacuation_essential }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @evacuation_essential.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /evacuation_essentials/1 or /evacuation_essentials/1.json
  def destroy
    @evacuation_essential.destroy
    
    respond_to do |format|
      format.html { redirect_to evacuation_essentials_url, notice: "Evacuation essential was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_index_breadcrumb
    add_breadcrumb('Evacuation Essentials', evacuation_essentials_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evacuation_essential
      @evacuation_essential = EvacuationEssential.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def evacuation_essential_params
      params.require(:evacuation_essential).permit(:name, :description, :ess_type)
    end
end
