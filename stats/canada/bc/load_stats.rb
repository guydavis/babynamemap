#!/usr/bin/env ruby
#  Parse the text files to load the BC name statistics into the database.
#
# Got the data by copy/pasting from http://www.vs.gov.bc.ca/babynames/index.html
# Text contained some single letters to mark sections and "TAKE ME BACK" links,
# but this will skip over these junk lines.
#
# Usage: ruby load_data.rb [12]*
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("British Columbia")
region.lat = 54.1125
region.lng = -126.5576
region.country = "Canada"
region.country_code = 'CA'
region.region_code = 'BC'
region.current_year = 2006
region.stats_name = "BC Vital Statistics Agency"
region.stats_url = "http://www.vs.gov.bc.ca/babynames/index.html"
region.stats_desc = "All baby names used five or more times in BC."
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
    calc_popularity(gender, region)
  end
  puts "Finished " + filename
end
