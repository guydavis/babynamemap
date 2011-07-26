#!/usr/bin/env ruby
#
# http://www.ocba.sa.gov.au/bdm/babynames.html?startat=0&showsize=1743&orderby=name&gender=male&year=2006&friendly=printable
# Usage: ruby scrape.rb
#

require 'net/http'
require 'uri'

for year in (2007..2007)
  for gender in ['male', 'female']
    res = Net::HTTP.post_form(URI.parse('http://www.ocba.sa.gov.au/bdm/babynames.html'),
       {'year'=>year, 'gender'=>gender, 'startat'=>0, 'showsize'=>10000,
        'friendly'=>'printable','orderby'=>'name'})
    file = File.open((year.to_s + '_' + gender + '.html'), "w")
    file.puts res.body()
    file.close()
  end
end
