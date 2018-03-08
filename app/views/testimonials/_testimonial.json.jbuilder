json.extract! testimonial, :id, :title, :body, :cloudy_id, :member_id, :created_at, :updated_at
json.url testimonial_url(testimonial, format: :json)
