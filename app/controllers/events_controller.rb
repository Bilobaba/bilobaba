require 'pry'


class EventsController < ApplicationController


  before_action :require_login, only: %i[new duplicate edit update destroy]
  before_action :set_event, only: %i[show edit duplicate update destroy show2]
  before_action :require_permission, only: %i[edit update destroy]
  before_action :set_list_events, only: %i[update destroy]
  after_action :list_categories, only: %i[create edit update destroy]

  # GET /events
  # GET /events.json
  def index
    @h1_title = 'Les propositions à venir'
    @events = Event.next_events
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @h1_title = @event.title
    @comment = Comment.new
  end

  def show2
    @h1_title = @event.title
    @comment = Comment.new
  end

  # GET /events/new
  def new
    @h1_title = 'Ajouter votre proposition'
    @event = Event.new
    @event.begin_at = @event.end_at = DateTime.now + 1.hours #local hour
    # $teachers is global because if !create return view with @teachers wrong
    $teachers = Member.all
    @category_list = current_member.category_list.sort.join(', ').to_s
  end

  # GET /events/duplicate/:id
  def duplicate
    @h1_title = 'Dupliquer cette proposition'
    # category_list is not in database table Event
    @category_list = @event.category_list.sort.join(', ').to_s
    @event = @event.dup
    @event.calendar_string = nil
    @event.multi_dates_id = nil
    @event.calendar_range_string = nil
    # $teachers is global because if !create return view with @teachers wrong
    $teachers = (Member.pros << current_member).reverse.uniq
    render :new
  end


  # GET /events/1/edit
  def edit
    @h1_title = 'Modifier ma proposition'
    @h1_title += 'Formulaire de l\'ADMINISTRATEUR ' if (current_member && current_member.has_role?(ROLE_ADMIN))
    $teachers = (Member.pros << current_member).reverse.uniq
    # must have @category_list in case duplicate
    @category_list = @event.category_list.join(', ').to_s
  end

  # POST /events
  # POST /events.json
  def create

    @event = Event.new(event_params)

    # if @event.cloudy already exist => duplicate else create from scratch
    @cloudy = @event.cloudy ? @event.cloudy : Cloudy.create
    @save_is_ok = true

    # dates is range
    if @event.calendar_range_string.size > 0

      @event = Event.new(event_params)
      @event.organizer = ( current_member.has_role?(ROLE_ADMIN) && @event.teacher) ? @event.teacher : current_member
      @event.cloudy = @cloudy
      @event.duration = @event.end_at - @event.begin_at
      # force image to avoid uplaod a new image per event created
      @save_is_ok &&= @event.save

      if @save_is_ok
        ContactMailer.new_user_action('Nouvel évènement', @event.url).deliver_now
        @event.reload
        @cloudy.identifier = @event.image.filename
        @cloudy.prefix_cloudinary = 'http://res.cloudinary.com/' + YAML.load_file('config/cloudinary.yml')['production']['cloud_name'] + '/'
        @cloudy.save
        @event.index!
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
        @event.organizer = ( current_member.has_role?(ROLE_ADMIN) && @event.teacher) ? @event.teacher : current_member

        @event.cloudy = @cloudy
        # if local zone = Paris, the 2 instruction follow add + hours in execution but not in debug
        # so DO NOT CHANGE LOCAL ZONE
        time_at = I18n.l(@event.begin_at, format: '%H:%M')
        @event.begin_at  = DateTime.strptime(d+' '+time_at, '%d/%m/%Y %H:%M')
        time_at = I18n.l(@event.end_at, format: '%H:%M')
        @event.end_at  = DateTime.strptime(d+' '+time_at, '%d/%m/%Y %H:%M')
        @event.duration = @event.end_at - @event.begin_at

        # save once to get cloudinary infos, break if save not ok
        break unless @save_is_ok &&= @event.save

        if @save_is_ok
          ContactMailer.new_user_action('Nouvel évènement', @event.url).deliver_now
          if !@cloudy.identifier
            @event.reload
            @cloudy.identifier = @event.image.filename
            @cloudy.prefix_cloudinary = 'http://res.cloudinary.com/' + YAML.load_file('config/cloudinary.yml')['production']['cloud_name'] + '/'
            @cloudy.save
            params[:event].delete(:image)
          end
          @event.index!
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
      @event.duration = @event.end_at - @event.begin_at
      if @cloudy
        # init cloudy once with the first update
        unless @cloudy.identifier
          @event.reload
          @cloudy.identifier = @event.image.filename
          @cloudy.prefix_cloudinary = 'http://res.cloudinary.com/' + YAML.load_file('config/cloudinary.yml')['production']['cloud_name'] + '/'
          @cloudy.save
          params[:event].delete(:image)
        end
        @event.cloudy = @cloudy
      end
      @event.save
      @event.index!
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
        flash.now[:alert] = "Problème dans la suppression de l'évènement"
        format.html { render @event }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # search by category
  def category
    if params[:category]
      # @testimonials = Testimonial.published.tagged_with(params[:topic])
      @events = Event.tagged_with(params[:category])
      redirect_to events_url(category: params[:category])
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy(event)
    @delete_is_ok &&= event.destroy
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
    params[:event][:title] = capitalize_text(params[:event][:title])

    params.require(:event).permit(:title, :description, :begin_at, :end_at, :price_min, :price_max, :members_max,
                                  :address, :city, :zip, :lat, :lng, { photos: [] },:calendar_string,
                                  :calendar_range_string, :image, :photo1, :photo2, :photo3, :photo4,
                                  :note, :teacher_id, :place_name, :cloudy_id, :category_list, :tag, { tag_ids: [] }, :tag_ids)
  end

  def require_login
    flash[:message] = "Il faut vous connecter pour créer un événement" if (action_name == 'new')
    flash[:message] = "Il faut vous connecter pour modifier un événement" if (action_name == 'edit')
    flash[:message] = "Il faut vous connecter pour copier un événement" if (action_name == 'duplicate')
    redirect_to new_member_session_path unless member_signed_in?
  end

  def require_permission
    redirect_to permission_path unless (@event.organizer == current_member ||
              @event.teacher == current_member || current_member.has_role?(ROLE_ADMIN))
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
    if (@multi_dates_id)
      list_events = Event.where(multi_dates_id: @multi_dates_id)
    else
      list_events = []
    end

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

  def list_categories
    ViewDatum.categories
  end

end
