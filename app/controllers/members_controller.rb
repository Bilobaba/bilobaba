class MembersController < ApplicationController
  before_action :set_member, only: [:show]

  def index
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

  def show
    @h1_title = @member.first_name.to_s.capitalize + ' ' + @member.name.to_s.upcase
    @testimonials = showed_testimonials
    @testimonials_named = testimonials_name_member

    @next_workshop = @member.next_workshops.first
    @next_events = @member.events.first(4)
    @count_testimonials = Testimonial.count
    @list_testimonials = Testimonial.published.last(3)
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
