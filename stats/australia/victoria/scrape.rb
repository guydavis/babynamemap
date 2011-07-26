#!/usr/bin/env ruby
#
# http://online.justice.vic.gov.au/bdm/popular-names
# Usage: ruby scrape_usa.rb
#
#http://online.justice.vic.gov.au/bdm/popular-names?#SeaYear=1929&SeaYearDecade=&SeaGender=Female&SeaMostPopular=100&action=Search

require 'net/http'
require 'uri'

for year in (2007..2007)
  for gender in ['Male', 'Female']
    res = Net::HTTP.post_form(URI.parse('http://online.justice.vic.gov.au/bdm/popular-names'),
       {'SeaYear'=>year, 'SeaGender'=>gender, 'SeaMostPopular'=>100, 
       'SeaYearDecade'=>'', 'action'=>'Search' })
    
    file = File.open((year.to_s + '_' + gender + '.html'), "w")
    file.puts res.body()
    file.close()
  end
end
