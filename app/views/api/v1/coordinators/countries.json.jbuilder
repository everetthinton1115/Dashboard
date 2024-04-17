json.message "success"
json.success true
json.data @countries.each do |country|
  json.code country.code
  json.name country.name
end