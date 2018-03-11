json.extract! view_datum, :id, :type, :content, :created_at, :updated_at
json.url view_datum_url(view_datum, format: :json)
