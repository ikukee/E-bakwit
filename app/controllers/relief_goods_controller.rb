class ReliefGoodsController < ApplicationController
  before_action :set_relief_good, only: %i[ show edit update destroy ]
  before_action :is_logged_in
  before_action :checkValidUser
  def search
    search_type = params[:search_type]
    if search_type == "UNIT"
      search_type = "unit"
    else
      search_type = "name"
    end
    @relief_goods = ReliefGood.where("#{search_type} LIKE ? ", "#{params[:search_value]}%").order(:name)
    respond_to do |format|
      if @relief_goods.length > 0
          format.turbo_stream{render turbo_stream: turbo_stream.update("relief_goods",partial: "search_results", locals:{relief_goods:@relief_goods })}
      elsif @relief_goods.length <= 0
          format.turbo_stream{render turbo_stream: turbo_stream.update("relief_goods","<h2 style = 'text-align:center'>No Record/s found.</h2>")}
      end
    end
  end
  # GET /relief_goods or /relief_goods.json
  def index
    add_breadcrumb('Relief Goods')
    @relief_goods = ReliefGood.all
    @page = params.fetch(:page, 0).to_i
    if  @page < 0
        @page = 0
    end
    @relief_goods_count = @relief_goods.length
    @relief_goods_count_per_page = 10
    @relief_goods = ReliefGood.offset(@page * @relief_goods_count_per_page).limit(@relief_goods_count_per_page).order(:name)
  end

  # GET /relief_goods/1 or /relief_goods/1.json
  def show
  end

  # GET /relief_goods/new
  def new
    add_breadcrumb('Relief Goods', relief_goods_path)
    add_breadcrumb('Add Relief Goods')
    @relief_good = ReliefGood.new
  end

  # GET /relief_goods/1/edit
  def edit
    add_breadcrumb('Relief Goods', relief_goods_path)
    add_breadcrumb(@relief_good.name.titleize)
  end

  # POST /relief_goods or /relief_goods.json
  def create
    @relief_good = ReliefGood.new(relief_good_params)
    @relief_good.name = @relief_good.name.upcase

    respond_to do |format|
      if @relief_good.save
        format.html { redirect_to "/relief_goods", notice: "Relief good was successfully created." }
        format.json { render :show, status: :created, location: @relief_good }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @relief_good.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /relief_goods/1 or /relief_goods/1.json
  def update

    respond_to do |format|
      if @relief_good.update(relief_good_params)

        format.html { redirect_to  "/relief_goods", notice: "Relief good was successfully updated." }
        format.json { render :show, status: :ok, location: @relief_good }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @relief_good.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relief_goods/1 or /relief_goods/1.json
  def destroy
    @relief_good.destroy

    respond_to do |format|
      format.html { redirect_to relief_goods_url, notice: "Relief good was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relief_good
      @relief_good = ReliefGood.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def relief_good_params
      params.require(:relief_good).permit(:name, :is_food, :unit, :price, :eligibility, :category)
    end
end
