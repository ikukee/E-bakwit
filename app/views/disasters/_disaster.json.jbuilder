json.extract! disaster, :id, :name, :disaster_type, :year, :created_at, :updated_at
json.url disaster_url(disaster, format: :json)
