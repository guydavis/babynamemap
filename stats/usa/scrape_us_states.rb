#!/usr/bin/env ruby
#
# Scrape Social Security to load the USA name statistics into the database.
# Usage: ruby scrape_usa.rb
#

require File.dirname(__FILE__) + '/../../config/environment'

require 'net/http'
require 'uri'

states = ['AK','AL','AR','AZ','CA','CO','CT','DC','DE','FL','GA','HI','IA','ID','IL','IN',
'KS','KY','LA','MA','MD','ME','MI','MN','MO','MS','MT','NC','ND','NE','NH','NJ',
'NM','NV','NY','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VA','VT','WA',
'WI','WV','WY']

for state in states
  for year in (2008..2008)
    res = Net::HTTP.post_form(URI.parse('http://www.ssa.gov/cgi-bin/namesbystate.cgi'),
        {'year'=>year, 'state'=>state })
    file = File.open(state + ("/%d"%year) + ".html", "w")
    file.puts res.body()
    file.close()
  end
end
