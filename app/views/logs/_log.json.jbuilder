json.extract! log, :id, :user_id, :date, :note, :created_at, :updated_at
json.url log_url(log, format: :json)
