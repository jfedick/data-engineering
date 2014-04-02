json.array!(@purchase_data) do |purchase_datum|
  json.extract! purchase_datum, :id, :file
  json.url purchase_datum_url(purchase_datum, format: :json)
end
