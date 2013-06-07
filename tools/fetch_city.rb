#!/usr/bin/ruby
# encoding: utf-8

# fetch_city.rb - v1.1
# INOVITEX Team - S6 Genie Info
# Mathieu Paquette <m.paquette@inovitex.com>

require 'net/http'
require 'htmlentities'

city_file = "eastern_cities.csv"

city_full = Hash.new

uri = URI.parse("http://www.mamrot.gouv.qc.ca/repertoire-des-municipalites/fiche/region/05/")
http = Net::HTTP.new(uri.host,uri.port)
req = Net::HTTP::Get.new(uri.request_uri)
res = http.request(req)
content = res.body

regexp = /<td style="width: 14%;">(.*?)<\/td>
                        <td style="width: 19%;" class=".*">(.*?)<\/td>
                        <td style="width: 33%;"><a href=".*" >(.*?)<\/a><\/td>
                        <td style="width: 34%;"><a href=".*" >(.*?)<\/a><\/td>/i
city_result = content.scan(regexp)

city_result.each { |city|
  city_code = city[0]
  if city_full.has_key?(city_code)
    puts city_code + " already exist in the city hash"
  else
    city_full[city_code] = { "city_name" => city[2],
                             "city_type" => city[1],
                             "MRC" => city[3] }
  end
}

File.open(city_file, 'a+') { |file|

  city_full.each { |key, value|
    file.write("\"" + key + "\"" + ",")
    file.write("\"" + value["city_name"] + "\"" + ",")
    file.write("\"" + value["city_type"] + "\"" + ",")
    file.write("\"" + value["MRC"] + "\"" + "\n")
  }
}

puts "Script finished!"
