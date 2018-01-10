json.extract! event, :id, :title, :description, :begin_at, :end_at, :price_min, :price_max, :address, :city, :zip, :lat, :lng, :organizer, :created_at, :updated_at
json.url event_url(event, format: :json)
