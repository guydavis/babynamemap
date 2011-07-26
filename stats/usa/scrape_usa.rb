#!/usr/bin/env ruby
#
# Scrape Social Security to load the USA name statistics into the database.
# Usage: ruby scrape_usa.rb
#

require File.dirname(__FILE__) + '/../../config/environment'

require 'net/http'
require 'uri'

for year in (2008..2008)
  res = Net::HTTP.post_form(URI.parse('http://www.ssa.gov/cgi-bin/popularnames.cgi'),
       {'year'=>year, 'number'=>'n', 'top' => 1000})
  file = File.open(("USA/%d.html"%year), "w")
  file.puts res.body()
  file.close()
end
