require 'pry'

class TestimonialsController < ApplicationController
  before_action :set_testimonial, only: [:show, :edit, :update, :destroy]
  before_action :require_login, only: %i[new edit update destroy]
  before_action :require_permission, only: %i[edit update destroy]
  after_action :list_topics, only: %i[create edit update destroy]

  # GET /testimonials
  # GET /testimonials.json
  def index
    if params[:topic]
      @topic = params[:topic]
      @testimonials = (Testimonial.published.tagged_with(params[:topic]) +
        ( member_signed_in? ? current_member.testimonials.tagged_with(params[:topic]) : [] )).uniq.sort_by{|obj| obj.title}
    else
      @testimonials = (Testimonial.published +
        ( member_signed_in? ? current_member.testimonials : [] )).uniq.sort_by{|obj| obj.title}
    end
  end

  # GET /testimonials/1
  # GET /testimonials/1.json
  def show
    @h1_title = @testimonial.title
    @read_duration = [1, @testimonial.body.split.size / 250].max
    @comment = Comment.new
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
    @testimonial.author = current_member
    respond_to do |format|
      if @testimonial.save
        format.html { redirect_to @testimonial, notice: 'Testimonial was successfully created.' }
        format.json { render :show, status: :created, location: @testimonial }
        ContactMailer.new_user_action('Nouveau témoignage', @testimonial.url).deliver_now
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
      flash[:message] = "Il faut vous connecter pour créer un témoignage" if (action_name == 'new')
      flash[:message] = "Il faut vous connecter pour modifier un témoignage" if (action_name == 'edit')
      redirect_to new_member_session_path unless member_signed_in?
    end

    def require_permission
      redirect_to permission_path unless (@testimonial.author == current_member ||
            current_member.has_role?(ROLE_ADMIN))
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def testimonial_params
      params.require(:testimonial).permit(:title, :body, :image, :published, :topic_list, :member_list, :tag, { tag_ids: [] }, :tag_ids)
    end

    # list testimonials showed for a member
    def list_showed
      if member_signed_in?
        list = (Testimonial.published + current_member.testimonials).uniq
      else
        list = Testimonial.published
      end
      return list
    end

    # set view_data topics for tags input
    def list_topics
      ViewDatum.topics
    end
end
