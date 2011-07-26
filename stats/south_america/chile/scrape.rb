#!/usr/bin/env ruby
#
# Parse Chilean stats for all years 
# Usage: ruby scrape.rb
#

require File.dirname(__FILE__) + '/../../../config/environment'

require 'net/http'
require 'uri'

for year in (1990..2006)
  res = Net::HTTP.post_form(URI.parse('http://www.registrocivil.cl/Servicios/Estadisticas/Archivos/NombresComunes/' + year.to_s + ".html"),
       {})
  file = File.open(("%d.html"%year), "w")
  file.puts res.body()
  file.close()
end
