require 'pry'

class EventsController < ApplicationController
  before_action :require_login, only: %i[new edit update destroy participate interact_with]
  before_action :set_event, only: %i[show edit update destroy participate interact_with]

  # GET /events
  # GET /events.json
  def index
    @h1_title = 'Les prochains évènements'
    @events = Event.next_events
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @h1_title = @event.title
    @comment = Comment.new
  end

  # GET /events/new
  def new
    @h1_title = 'Ajout d\'un nouvel évènement'
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @h1_title = 'Modifier mon évènement'
  end

  # POST /events
  # POST /events.json
  def create

    @event = Event.new(event_params)

    # One only date
    if @event.calendar_string == ""
      create_event(@event)

    # Loop for all calendar_string
    else
      tab_dates = @event.calendar_string.split(',')

      tab_dates.each do |d|
        @event = Event.new(event_params)

        time_at = I18n.l(@event.begin_at, format: '%H:%M')
        @event.begin_at  = DateTime.strptime(d+' '+time_at, '%d/%m/%Y %H:%M')

        time_at = I18n.l(@event.end_at, format: '%H:%M')
        @event.end_at  = DateTime.strptime(d+' '+time_at, '%d/%m/%Y %H:%M')

        create_event(@event)
      end
    end

    respond_to do |format|
      format.html { redirect_to @event}
      format.json { render :show, status: :created, location: @event }
    end

  end

  def create_event(event)
    @event = event
    @event.organizer = current_member

    if @event.save
      @event.algolia_index!
      # not respond, wait create end loop multi creating
    else
      respond_to do |format|
        # simple_form doesn t show errors for :begin_at & :end_at because
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        @event.algolia_index!
        format.html { redirect_to @event}
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.algolia_remove_from_index!
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url}
      format.json { head :no_content }
    end
  end

  def participate
    @event.participate(current_member)

    # @author = current_member.pseudo
    # @email = current_member.email
    # @message = 'yoyo'

    # if params[:status] == 'in'
    #   ContactMailer.event_participate(@author, @email, @message).deliver_now
    # elsif params[:status] == 'out'
    #   ContactMailer.event_leave(@author, @email, @message).deliver_now
    # end
  end

  def interact_with
    @link_id = params.permit(:type)[:type]
    case @link_id
    when 'go'
      participate
    when 'like'
      @event.like(current_member)
    when 'recommend'
      @event.recommend(current_member)
    when 'follow'
      @event.follow(current_member)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:title, :description, :begin_at, :end_at, :price_min, :price_max, :members_max,
                                  :address, :city, :zip, :lat, :lng, { photos: [] },
                                  :calendar_string, :image, :photo1, :photo2, :photo3, :photo4)
  end

  def require_login
    redirect_to forbidden_path unless member_signed_in?
  end
end
