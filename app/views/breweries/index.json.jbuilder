json.array!(@breweries) do |brewery|
  json.extract! brewery, :id, :name, :year
  json.beers brewery.beers.count
end
