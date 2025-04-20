json.extract! diagnostic, :id, :user_id, :raw_input, :gpt_response, :risk_level, :created_at, :updated_at
json.url diagnostic_url(diagnostic, format: :json)
