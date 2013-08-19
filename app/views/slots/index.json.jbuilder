json.array!(@slots) do |slot|
  json.extract! slot, :possible_downloads, :state, :size, :file
  json.url slot_url(slot, format: :json)
end
