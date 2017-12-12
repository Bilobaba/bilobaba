class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy participate like recommend follow]

  # GET /events
  # GET /events.json
  def index
    @events = get_events
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @comment = Comment.new
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit; end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.organizer = current_member

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
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
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
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
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def participate
    @event.participate(current_member, params[:status])

    @author = current_member.pseudo
    @email = current_member.email
    @message = 'yoyo'

    if params[:status] == 'in'
      ContactMailer.event_participate(@author, @email, @message).deliver_now
    elsif params[:status] == 'out'
      ContactMailer.event_leave(@author, @email, @message).deliver_now
    end

    @events = get_events
  end

  def like
    @event.like(current_member, params[:status])
  end

  def recommend
    @event.recommend(current_member, params[:status])
  end

  def follow
    @event.follow(current_member, params[:status])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  def get_events
    Event
    .order(begin: :asc)
    .where('begin >= ?', Time.now)
    .includes(:attendees)
    .includes(:comments)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:title, :description, :begin, :end, :price_min, :price_max,
                                  :adress, :town, :zip, :lat, :lng, { photos: [] }, :image, :photo1, :photo2, :photo3, :photo4)
  end
end
