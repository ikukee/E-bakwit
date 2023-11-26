class DisastersController < ApplicationController
  before_action :set_disaster, only: %i[ show edit update destroy ]
  before_action :add_index_breadcrumb, only: [:new, :edit]
  before_action :is_logged_in
  before_action :checkValidUser

  # GET /disasters or /disasters.json
  def index
    add_breadcrumb('Disasters')
    @disasters = Disaster.all
    @page = params.fetch(:page, 0).to_i
    if  @page < 0
        @page = 0
    end
    @disasters_count = @disasters.length
    @disasters_count_per_page = 5
    @disasters = Disaster.offset(@page * @disasters_count_per_page).limit(@disasters_count_per_page).order(:name)
  end

  def search
    search_type = params[:search_type]
    if search_type == "YEAR"
      search_type = "year"
    elsif search_type == "TYPE"
      search_type = "disaster_type"
    else
      search_type = "name"
    end
    @disasters = Disaster.where("#{search_type} LIKE ? ", "#{params[:search_value]}%").order(:name)
    respond_to do |format|
      if @disasters.length > 0
          format.turbo_stream{render turbo_stream: turbo_stream.update("disasters",partial: "search_results", locals:{disasters:@disasters })}
      elsif @disasters.length <= 0
          format.turbo_stream{render turbo_stream: turbo_stream.update("disasters","<h2 style = 'text-align:center'>No Record/s found.</h2>")}
      end
    end
  end


  # GET /disasters/1 or /disasters/1.json
  def show
  end

  # GET /disasters/new
  def new
    @disaster = Disaster.new
    add_breadcrumb('New Disaster')
  end

  # GET /disasters/1/edit
  def edit
    add_breadcrumb(@disaster.name.titleize)
  end

  # POST /disasters or /disasters.json
  def create
    @disaster = Disaster.new(disaster_params)
    @disaster.name = @disaster.name.upcase
    @disaster.year = @disaster.date_of_occurence.year
    respond_to do |format|
      if @disaster.save
        format.html { redirect_to "/disasters", notice: "Disaster was successfully created." }
        format.json { render :show, status: :created, location: @disaster }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @disaster.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /disasters/1 or /disasters/1.json
  def update
    respond_to do |format|
      params[:disaster][:name]  = params[:disaster][:name].upcase
      @disaster.year = @disaster.date_of_occurence.year
      if @disaster.update(disaster_params)
        format.html { redirect_to "/disasters", notice: "Disaster was successfully updated." }
        format.json { render :show, status: :ok, location: @disaster }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @disaster.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /disasters/1 or /disasters/1.json
  def destroy
    @disaster.destroy

    respond_to do |format|
      format.html { redirect_to disasters_url, notice: "Disaster was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_index_breadcrumb
    add_breadcrumb('Disasters', disasters_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_disaster
      @disaster = Disaster.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def disaster_params
      params.require(:disaster).permit(:name, :disaster_type, :year, :date_of_occurence)
    end
end
