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
    @event.begin_at = @event.end_at = DateTime.now + 1.hours #local hour
  end

  # GET /events/1/edit
  def edit
    @h1_title = 'Modifier mon évènement'
  end

  # POST /events
  # POST /events.json
  def create

    # multi_dates_id = Time.new is Id group of all items
    @event = Event.new(event_params)
    tab_dates = @event.calendar_string.split(',')
    time_stamp = Time.new

    @save_is_ok = tab_dates.count > 0

    flash[:alert] = "Il faut choisir une ou plusieurs dates" unless @save_is_ok


    tab_dates.each do |d|
      @event = Event.new(event_params)
      @event.multi_dates_id = time_stamp if tab_dates.count > 1
      @event.organizer = current_member

      time_at = I18n.l(@event.begin_at, format: '%H:%M')
      @event.begin_at  = DateTime.strptime(d+' '+time_at, '%d/%m/%Y %H:%M')

      time_at = I18n.l(@event.end_at, format: '%H:%M')
      @event.end_at  = DateTime.strptime(d+' '+time_at, '%d/%m/%Y %H:%M')

      create_event(@event)

    end

    respond_to do |format|
      if @save_is_ok
        format.html { redirect_to @event}
        format.json { render :show, status: :created, location: @event }
      else
        # simple_form doesn t show errors for :begin_at & :end_at because
        flash[:alert] = "Problème dans la création de l événement"
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end

  end

  def create_event(event)
    @event = event
    @save_is_ok &&= @event.save
  end

  def update

    # if delete, we need form to get type_upadte
    if params[:commit] == ACTION_SUPPRIMER
      destroy_events
      return
    end

    @update_is_ok = true
    list_events = case params[:type_update]
      when UPDATE_TYPE_ALL_ITEMS  then Event.where(multi_dates_id: @event.multi_dates_id)
      when UPDATE_TYPE_ALL_AFTER  then Event.where(multi_dates_id: @event.multi_dates_id).where("begin_at >= ?", @event.begin_at)
      else [@event]
    end

    list_events.each do |event|
      # binding.pry
      update_event(event)
      # binding.pry
    end

    respond_to do |format|
      if @update_is_ok
        format.html { redirect_to @event}
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end

    # binding.pry
  end


  def update_event(event)

    @event = event
# binding.pry
    #update with params from view
    @update_is_ok &&= @event.update(event_params)
# binding.pry
    # for multi dates get old values date begin_at & end_at but not time
    if event.multi_dates_id
      #get new record which is != @event since CarrierWave change the update
      @event.reload

      #get day as old value
      change_day(@event,event.begin_at)

      #save again
      # binding.pry
      @update_is_ok &&= @event.save
      # binding.pry
    end
  end

  def destroy_events

    @delete_is_ok = true

    list_events = case params[:type_update]
      when UPDATE_TYPE_ALL_ITEMS  then Event.where(multi_dates_id: @event.multi_dates_id)
      when UPDATE_TYPE_ALL_AFTER  then Event.where(multi_dates_id: @event.multi_dates_id).where("begin_at >= ?", @event.begin_at)
      else [@event]
    end

    list_events.each do |event|
      destroy(event)
    end

    respond_to do |format|
      if @delete_is_ok
        format.html { redirect_to @event}
        format.json { render :show, status: :created, location: @event }
      else
        # simple_form doesn t show errors for :begin_at & :end_at because
        flash.now[:alert] = "Problème dans la suppression de l évènement"
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy(event)
    @event = event
    @delete_is_ok &&= @event.destroy
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

    # in the form, there are field for day/date AND fiel for time/hh:mm
    params[:event]["begin_at"] = DateTime.new(params[:event]["begin_at(1i)"].to_i,
                                  params[:event]["begin_at(2i)"].to_i,
                                  params[:event]["begin_at(3i)"].to_i,
                                  params[:event]["begin_at(4i)"].to_i,
                                  params[:event]["begin_at(5i)"].to_i)

    params[:event]["end_at"] = DateTime.new(params[:event]["end_at(1i)"].to_i,
                                  params[:event]["end_at(2i)"].to_i,
                                  params[:event]["end_at(3i)"].to_i,
                                  params[:event]["end_at(4i)"].to_i,
                                  params[:event]["end_at(5i)"].to_i)

    params.require(:event).permit(:title, :description, :begin_at, :end_at, :price_min, :price_max, :members_max,
                                  :address, :city, :zip, :lat, :lng, { photos: [] },
                                  :calendar_string, :image, :photo1, :photo2, :photo3, :photo4)
  end

  def require_login
    redirect_to forbidden_path unless member_signed_in?
  end

  # change only the day of DateTime
  def change_day(event,day)
    # binding.pry
      day_at = I18n.l(day, format: '%d/%m/%Y')

      time_at = I18n.l(event.begin_at, format: '%H:%M')
      event.begin_at  = DateTime.strptime(day_at+' '+time_at, '%d/%m/%Y %H:%M')

      time_at = I18n.l(event.end_at, format: '%H:%M')
      event.end_at  = DateTime.strptime(day_at+' '+time_at, '%d/%m/%Y %H:%M')
    # binding.pry
  end
end
