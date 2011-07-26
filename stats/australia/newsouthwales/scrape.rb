#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../../../config/environment'

require 'net/http'
require 'uri'

for year in (2007..2007)
  for gender in ['Male', 'Female']
    res = Net::HTTP.post_form(URI.parse('http://www.bdm.nsw.gov.au/cgi-bin/popularNames.cgi'),
       {'year'=>year, 'gender'=>gender, 'search' => 'Top 100' })
    file = File.open(("%d"%year + "_" + gender + ".html"), "w")
    file.puts res.body()
    file.close()
  end
end
