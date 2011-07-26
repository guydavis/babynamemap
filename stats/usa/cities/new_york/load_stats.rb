#!/usr/bin/env ruby
# Parse the data for the city of New York, from the PDF release
#
# Usage: ruby load_data.rb *txt
#

require File.dirname(__FILE__) + '/../../../../config/environment'
require File.dirname(__FILE__) + '/../../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("New York City")
region.lat = 40.7145
region.lng = -74.0071
region.country = "USA"
region.country_code = 'US'
region.current_year = 2006
region.stats_name = "The New York City Department of Health and Mental Hygiene"
region.stats_url = "http://www.nyc.gov/html/doh/html/pr2006/prindex_en_0.shtml"
region.stats_desc = "All baby names used ten or more times."
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
      for pair in line.scan(/\d+\s+([^\d]+)\s+(\d+)/)
        name = pair[0].strip.capitalize
        count = Integer(pair[1].strip)
        load_stat(name, count, year, gender, region)
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
