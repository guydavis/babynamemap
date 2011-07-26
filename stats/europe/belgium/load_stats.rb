#!/usr/bin/env ruby
#
# Usage: ruby load_data.rb *html
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Belgium")
region.lat = 50.5039
region.lng = 4.4699
region.country = "Belgium"
region.country_code = 'BE'
region.current_year = 2006
region.stats_name = "Algemene Directie Statistiek en Economische Informatie"
region.stats_url = "http://statbel.fgov.be/figures/d22a_nl.asp"
region.stats_desc = "All baby names given throughout the country."
region.save

# Now parse every text file that was provided.  
for filename in ARGV
  filename =~ /^[0-9]{4}/
  year = Integer($&) # Get year from previous regexp on filename
  if filename =~ /boy/i
    gender = "MALE"
  else
    gender = "FEMALE"
  end
  File.open(filename) do | file |
    while line = file.gets
     for pair in line.scan(/([^\d]+)(\d+)/)
        load_stat(pair[0].strip, Integer(pair[1]), year, gender, region)
      end
    end
  end

  if (year == region.current_year)
    for gender in ['MALE', 'FEMALE']
      calc_popularity(gender, region)
    end
  end
  puts "Finished " + filename
end
