require 'rails_helper'

describe "BeermappingApi" do

  describe "in case of cache miss" do

    before :each do
      Rails.cache.clear
    end

    it "When HTTP GET returns one entry, it is parsed and returned" do

      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      places = BeermappingApi.places_in("espoo")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Gallows Bird")
      expect(place.street).to eq("Merituulentie 30")
    end

    it "When HTTP GET does not return entries, empty array is returned" do

      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*kaliala/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      places = BeermappingApi.places_in("kaliala")

      expect(places.size).to eq(0)
      place = places.first
      expect(place).to eq(nil)
    end

    it "When HTTP GET return many entries, they are parsed and returned" do
      palses = [ Place.new( name:"The Aldgate", id: 1 ),
                 Place.new( name:"Watering Hole", id: 2 ),
                 Place.new( name:"Lupulin", id: 3 )  ]
      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12333</id><name>The Aldgate</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12333</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12333&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12333&amp;d=1&amp;type=norm</blogmap><street>Shin-iwasaki building 3F, 30-4 Udagawa-cho, Shibuy</street><city>Tokyo</city><state></state><zip>150-0042</zip><country>Japan</country><phone>03-3462-2983</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>18830</id><name>Watering Hole</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=18830</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18830&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18830&amp;d=1&amp;type=norm</blogmap><street>5-26-5-103 Sendagaya</street><city>Tokyo</city><state></state><zip>151-0051</zip><country>Japan</country><phone>03 6380 6115</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>19120</id><name>Lupulin</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=19120</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=19120&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=19120&amp;d=1&amp;type=norm</blogmap><street>Urano bldg, 3:rd floor, 6 Chome-7 Ginza</street><city>Tokyo</city><state></state><zip>104-0061</zip><country>Japan</country><phone></phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*tokyo/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      places = BeermappingApi.places_in("tokyo")
      expect(places.size).to eq(3)

      places.each_with_index do |place, index|
        expect(place.name).to eq(palses[index].name)
      end

    end
  end

  describe "in case of cache hit" do

    it "When HTTP GET returns one entry, it is parsed and returned" do

      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      places = BeermappingApi.places_in("espoo")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Gallows Bird")
      expect(place.street).to eq("Merituulentie 30")
    end

    it "When HTTP GET does not return entries, empty array is returned" do

      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*kaliala/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      places = BeermappingApi.places_in("kaliala")

      expect(places.size).to eq(0)
      place = places.first
      expect(place).to eq(nil)
    end

    it "When HTTP GET return many entries, they are parsed and returned" do
      palses = [ Place.new( name:"The Aldgate", id: 1 ),
                 Place.new( name:"Watering Hole", id: 2 ),
                 Place.new( name:"Lupulin", id: 3 )  ]
      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12333</id><name>The Aldgate</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12333</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12333&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12333&amp;d=1&amp;type=norm</blogmap><street>Shin-iwasaki building 3F, 30-4 Udagawa-cho, Shibuy</street><city>Tokyo</city><state></state><zip>150-0042</zip><country>Japan</country><phone>03-3462-2983</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>18830</id><name>Watering Hole</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=18830</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18830&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18830&amp;d=1&amp;type=norm</blogmap><street>5-26-5-103 Sendagaya</street><city>Tokyo</city><state></state><zip>151-0051</zip><country>Japan</country><phone>03 6380 6115</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>19120</id><name>Lupulin</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=19120</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=19120&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=19120&amp;d=1&amp;type=norm</blogmap><street>Urano bldg, 3:rd floor, 6 Chome-7 Ginza</street><city>Tokyo</city><state></state><zip>104-0061</zip><country>Japan</country><phone></phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*tokyo/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      places = BeermappingApi.places_in("tokyo")
      expect(places.size).to eq(3)

      places.each_with_index do |place, index|
        expect(place.name).to eq(palses[index].name)
      end
    end
  end
end
