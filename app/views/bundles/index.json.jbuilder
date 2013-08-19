json.array!(@bundles) do |bundle|
  json.extract! bundle, :state, :possible_downloads, :destroy_code, :zip_archive, :text, :code
  json.url bundle_url(bundle, format: :json)
end
