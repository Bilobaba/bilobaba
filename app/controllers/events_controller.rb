require 'pry'


class EventsController < ApplicationController
  before_action :require_login, only: %i[new edit update destroy participate interact_with]
  before_action :set_event, only: %i[show edit update destroy participate interact_with]
  before_action :set_list_events, only: %i[update destroy]

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

    @event = Event.new(event_params)
    @cloudy = Cloudy.create
    @save_is_ok = true

    # dates is range
    if @event.calendar_range_string.size > 0

      @event = Event.new(event_params)

      @event.organizer = current_member
      @event.cloudy = @cloudy

      # force image to avoid uplaod a new image per event created
      @save_is_ok &&= @event.save

      if @save_is_ok
        @event.reload
        @cloudy.identifier = @event.image.filename
        @cloudy.save
      end

    elsif @event.calendar_string.size > 0

      # multi_dates_id = Time.new is Id group of all items
      tab_dates = @event.calendar_string.split(',')
      time_stamp = Time.new

      @save_is_ok = tab_dates.count > 0

      flash[:alert] = "Il faut choisir une ou plusieurs dates" unless @save_is_ok


      tab_dates.each do |d|
        @event = Event.new(event_params)
        @event.multi_dates_id = time_stamp if tab_dates.count > 1
        @event.organizer = current_member
        @event.cloudy = @cloudy


        time_at = I18n.l(@event.begin_at, format: '%H:%M')
        @event.begin_at  = DateTime.strptime(d+' '+time_at, '%d/%m/%Y %H:%M')

        time_at = I18n.l(@event.end_at, format: '%H:%M')
        @event.end_at  = DateTime.strptime(d+' '+time_at, '%d/%m/%Y %H:%M')

        # save once to get cloudinary infos, break if save not ok
        break unless @save_is_ok &&= @event.save

        if !@cloudy.identifier && @save_is_ok

          @event.reload
          @cloudy.identifier = @event.image.filename
          @cloudy.save
          params[:event].delete(:image)
        end
      end
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

  def update

    # if delete, we need form to get type_upadte
    if params[:commit] == ACTION_SUPPRIMER
      destroy_events
      return
    end

    @update_is_ok = true
    @cloudy = Cloudy.new if params[:event][:image]
    @list_events.each do |event|
      @event = event
      @update_is_ok &&= @event.update(event_params)
      if @cloudy
        # init cloudy once with the first update
        unless @cloudy.identifier
          @event.reload
          @cloudy.identifier = @event.image.filename
          @cloudy.save
          params[:event].delete(:image)
        end
        @event.cloudy = @cloudy
        @event.save
      end
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

  end


  def destroy_events

    @delete_is_ok = true
    @multi_dates_id = @event.multi_dates_id

    @list_events.each do |event|
      destroy(event)
    end

    set_update_calendar_string

    respond_to do |format|
      if @delete_is_ok
      format.html { redirect_to events_url}
      format.json { head :no_content }
      else
        # simple_form doesn t show errors for :begin_at & :end_at because
        flash.now[:alert] = "Problème dans la suppression de l évènement"
        format.html { render @event }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy(event)
    @delete_is_ok &&= event.destroy
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

  # Set the list of events / TYPE_UPADTE
  def set_list_events
    @list_events = case params[:type_update]
      when UPDATE_TYPE_ALL_ITEMS  then Event.where(multi_dates_id: @event.multi_dates_id)
      when UPDATE_TYPE_ALL_AFTER  then Event.where(multi_dates_id: @event.multi_dates_id).where("begin_at >= ?", @event.begin_at)
      else [@event]
      end
  end

  def event_params_date
    # if range, event during several days
    if params[:event][:calendar_range_string].size > 0
      calendar_range_string = params[:event][:calendar_range_string].delete(' ').split('-')

      @begin_at  = DateTime.strptime(calendar_range_string[0]+params[:event]["begin_at(4i)"]+params[:event]["begin_at(5i)"],
        '%d/%m/%Y%H%M')
      @end_at  = DateTime.strptime(calendar_range_string[1]+params[:event]["end_at(4i)"]+params[:event]["end_at(5i)"],
        '%d/%m/%Y%H%M')

    # mono or multidate for persisted event
    # if persisted & multi date & not range : not change the day but only hh:mm / destroy doesn't need @event but list_events
    elsif (@event && @event.persisted?) && (@event.multi_dates_id)
      # if persisted & multi date : not change the day but only hh:mm
        @begin_at = DateTime.new(@event.begin_at.year, @event.begin_at.month, @event.begin_at.day,
                                              params[:event]["begin_at(4i)"].to_i,params[:event]["begin_at(5i)"].to_i)

        @end_at = DateTime.new(@event.end_at.year, @event.end_at.month, @event.end_at.day,
                                              params[:event]["end_at(4i)"].to_i,params[:event]["end_at(5i)"].to_i)

    # elsif only one get the date in calendar_string
    elsif !params[:event][:calendar_string].include?(',')
        # day is given by calendar_string = 1 only date
        @begin_at = DateTime.strptime(params[:event][:calendar_string] + ' ' +
                                              params[:event]["begin_at(4i)"] + ':' + params[:event]["begin_at(5i)"],
                                              '%d/%m/%Y %H:%M')

        @end_at = DateTime.strptime(params[:event][:calendar_string] + ' ' +
                                              params[:event]["end_at(4i)"] + ':' + params[:event]["end_at(5i)"],
                                              '%d/%m/%Y %H:%M')
    # take the first date
    else
        @begin_at = DateTime.strptime(params[:event][:calendar_string].split(',')[0] + ' ' +
                                              params[:event]["begin_at(4i)"] + ':' + params[:event]["begin_at(5i)"],
                                              '%d/%m/%Y %H:%M')

        @end_at = DateTime.strptime(params[:event][:calendar_string].split(',')[0] + ' ' +
                                              params[:event]["end_at(4i)"] + ':' + params[:event]["end_at(5i)"],
                                              '%d/%m/%Y %H:%M')

    end

    # remove infos on day from form by params
    params[:event]["begin_at(1i)"] = @begin_at.year.to_s
    params[:event]["begin_at(2i)"] = @begin_at.month.to_s
    params[:event]["begin_at(3i)"] = @begin_at.day.to_s

    params[:event]["end_at(1i)"] = @end_at.year.to_s
    params[:event]["end_at(2i)"] = @end_at.month.to_s
    params[:event]["end_at(3i)"] = @end_at.day.to_s


  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    # compute @begin_at @end_at
    event_params_date
    params[:event][:begin_at] = @begin_at
    params[:event][:end_at] = @end_at

    params.require(:event).permit(:title, :description, :begin_at, :end_at, :price_min, :price_max, :members_max,
                                  :address, :city, :zip, :lat, :lng, { photos: [] },:calendar_string,
                                  :calendar_range_string, :image, :photo1, :photo2, :photo3, :photo4)
  end

  def require_login
    redirect_to forbidden_path unless member_signed_in?
  end

  # change only the day of DateTime but not hh:mm
  def change_day(event,day)
      day_at = I18n.l(day, format: '%d/%m/%Y')

      time_at = I18n.l(event.begin_at, format: '%H:%M')
      event.begin_at  = DateTime.strptime(day_at+' '+time_at, '%d/%m/%Y %H:%M')

      time_at = I18n.l(event.end_at, format: '%H:%M')
      event.end_at  = DateTime.strptime(day_at+' '+time_at, '%d/%m/%Y %H:%M')
  end

  # remove dates from calendar_string after delete events
  def set_update_calendar_string
    list_events = Event.where(multi_dates_id: @multi_dates_id)
    calendar_string_tab = []
    list_events.each do |event|
      calendar_string_tab << I18n.l(event.begin_at, format: '%d/%m/%Y')
    end

    calendar_string = calendar_string_tab.reverse!.join(',')

    list_events.each do |event|
      event.calendar_string = calendar_string
      @delete_is_ok &&= event.save
    end
  end

end
