json.extract! tracker, :id, :title, :url, :threshold_price, :enabled, :created_at, :updated_at
json.url tracker_url(tracker, format: :json)
