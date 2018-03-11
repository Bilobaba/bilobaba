class ViewDataController < ApplicationController
  before_action :set_view_datum, only: [:show, :edit, :update, :destroy]

  # GET /view_data
  # GET /view_data.json
  def index
    @view_data = ViewDatum.all
  end

  # GET /view_data/1
  # GET /view_data/1.json
  def show
  end

  # GET /view_data/new
  def new
    @view_datum = ViewDatum.new
  end

  # GET /view_data/1/edit
  def edit
  end

  # POST /view_data
  # POST /view_data.json
  def create
    @view_datum = ViewDatum.new(view_datum_params)

    respond_to do |format|
      if @view_datum.save
        format.html { redirect_to @view_datum, notice: 'View datum was successfully created.' }
        format.json { render :show, status: :created, location: @view_datum }
      else
        format.html { render :new }
        format.json { render json: @view_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /view_data/1
  # PATCH/PUT /view_data/1.json
  def update
    respond_to do |format|
      if @view_datum.update(view_datum_params)
        format.html { redirect_to @view_datum, notice: 'View datum was successfully updated.' }
        format.json { render :show, status: :ok, location: @view_datum }
      else
        format.html { render :edit }
        format.json { render json: @view_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /view_data/1
  # DELETE /view_data/1.json
  def destroy
    @view_datum.destroy
    respond_to do |format|
      format.html { redirect_to view_data_url, notice: 'View datum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_view_datum
      @view_datum = ViewDatum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def view_datum_params
      params.require(:view_datum).permit(:type, :content)
    end
end
