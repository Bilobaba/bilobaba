require 'pry'

class TestimonialsController < ApplicationController
  before_action :set_testimonial, only: [:show, :edit, :update, :destroy]
  before_action :require_login, only: %i[new edit update destroy]
  before_action :require_permission, only: %i[edit update destroy]
  after_action :list_topics, only: %i[create edit update destroy]

  # GET /testimonials
  # GET /testimonials.json
  def index
    @testimonials = list_showed
    if params[:topic]
      @testimonials = Testimonial.tagged_with(params[:topic])
    else
      @testimonials = Testimonial.all
    end
  end

  # GET /testimonials/1
  # GET /testimonials/1.json
  def show
    @h1_title = @testimonial.title
  end

  # GET /testimonials/new
  def new
    @h1_title = 'Ajouter votre témoignage'
    @testimonial = Testimonial.new
  end

  # GET /testimonials/1/edit
  def edit
  end

  # POST /testimonials
  # POST /testimonials.json
  def create
    @testimonial = Testimonial.new(testimonial_params)
    @testimonial.member = current_member
    respond_to do |format|
      if @testimonial.save
        format.html { redirect_to @testimonial, notice: 'Testimonial was successfully created.' }
        format.json { render :show, status: :created, location: @testimonial }
      else
        format.html { render :new }
        format.json { render json: @testimonial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /testimonials/1
  # PATCH/PUT /testimonials/1.json
  def update
    respond_to do |format|
      if @testimonial.update(testimonial_params)
        format.html { redirect_to @testimonial, notice: 'Testimonial was successfully updated.' }
        format.json { render :show, status: :ok, location: @testimonial }
      else
        format.html { render :edit }
        format.json { render json: @testimonial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /testimonials/1
  # DELETE /testimonials/1.json
  def destroy
    @testimonial.destroy
    respond_to do |format|
      format.html { redirect_to testimonials_url, notice: 'Testimonial was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_testimonial
      @testimonial = Testimonial.find(params[:id])
    end

    def require_login
      redirect_to forbidden_path unless member_signed_in?
    end

    def require_permission
      redirect_to permission_path unless (@testimonial.member == current_member ||
            current_member.has_role?(ROLE_ADMIN))
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def testimonial_params
      params.require(:testimonial).permit(:title, :body, :image, :published, :topic_list, :member_list, :tag, { tag_ids: [] }, :tag_ids)
    end

    def list_showed
      if member_signed_in?
        list = (Testimonial.published + current_member.testimonials).uniq
      else
        list = Testimonial.published
      end
      return list
    end

    def list_topics
      v = ViewDatum.find_by_data_type(VIEW_DATA_TOPICS)
      v.content = Tag.topics
      v.save
    end
end
