class TagginsController < ApplicationController
  before_action :set_taggin, only: [:show, :edit, :update, :destroy]

  # GET /taggins
  # GET /taggins.json
  def index
    @taggins = Taggin.all
  end

  # GET /taggins/1
  # GET /taggins/1.json
  def show
  end

  # GET /taggins/new
  def new
    @taggin = Taggin.new
  end

  # GET /taggins/1/edit
  def edit
  end

  # POST /taggins
  # POST /taggins.json
  def create
    @taggin = Taggin.new(taggin_params)

    respond_to do |format|
      if @taggin.save
        format.html { redirect_to @taggin, notice: 'Taggin was successfully created.' }
        format.json { render :show, status: :created, location: @taggin }
      else
        format.html { render :new }
        format.json { render json: @taggin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /taggins/1
  # PATCH/PUT /taggins/1.json
  def update
    respond_to do |format|
      if @taggin.update(taggin_params)
        format.html { redirect_to @taggin, notice: 'Taggin was successfully updated.' }
        format.json { render :show, status: :ok, location: @taggin }
      else
        format.html { render :edit }
        format.json { render json: @taggin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taggins/1
  # DELETE /taggins/1.json
  def destroy
    @taggin.destroy
    respond_to do |format|
      format.html { redirect_to taggins_url, notice: 'Taggin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_taggin
      @taggin = Taggin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def taggin_params
      params.require(:taggin).permit(:tag_id, :taggable_type, :taggable_id, :tagger_type, :tagger_id, :context)
    end
end
