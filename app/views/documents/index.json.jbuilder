json.array!(@documents) do |document|
  json.extract! document,  :id, :user_id, :content, :date, :lat, :lng, :weather
end