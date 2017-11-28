json.extract! event, :id, :title, :description, :begin, :end, :price_min, :price_max, :adress, :town, :zip, :lat, :lng, :organizer, :created_at, :updated_at
json.url event_url(event, format: :json)
