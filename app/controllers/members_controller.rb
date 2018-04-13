class MembersController < ApplicationController
  before_action :set_member, only: [:show]

  def index
  end

  # only by ADMIN
  def edit
    redirect_to root_path unless  current_member.has_role?(ROLE_ADMIN)
    @member = Member.find(params[:id])
  end


  # only by ADMIN
  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    @member = Member.find(params[:id])
    # See parameters from application_controller
    member =  params.require(:member).
      permit(
        :email, :password, :password_confirmation,
        :gender, :pseudo, :first_name, :name, :bio, :birth_date,
        :address, :zip, :city, :country, :avatar, :site,
        :category_list, :tag, { tag_ids: [] }, :tag_ids, :title

      )
    respond_to do |format|
      if @member.update(member)
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
    @member.index!
  end



  def index_pros
      @members = Member.with_role(ROLE_PROFESSIONAL).order(pseudo: :asc)
      @h1_title = 'Les proposants'
      render :index
  end

  def index_amateurs
      @members = Member.with_role(ROLE_AMATEUR).order(avatar: :asc).order(pseudo: :asc)
      @h1_title = 'Les membres'
      render :index
  end

  def index
      @members = Member.all.sort_by { |obj| obj.pseudo }
  end

  def show
    @h1_title = @member.first_name.to_s.capitalize + ' ' + @member.name.to_s.upcase
    @testimonials = showed_testimonials
    @testimonials_named = testimonials_name_member

    @next_workshops = @member.next_workshops
    @next_events = @member.next_events
    @past_activities = @member.past_activities
    @count_testimonials = Testimonial.count
    @testimonials_by = Testimonial.by(@member)
    @testimonials_about = Testimonial.about(@member)
  end

  private

  def set_member
    @member = Member.find(params[:id])
    redirect_to errors_member_path unless @member
  end

  def showed_testimonials
    if (current_member == @member)
      list = current_member.testimonials
    else
      list = @member.testimonials.published
    end
    return list
  end

  def testimonials_name_member
    list = []
    Testimonial.published.each do |t|
      if t.member_list.include?(@member.pseudo)
        list << t
      end
    end
    return list
  end
end
