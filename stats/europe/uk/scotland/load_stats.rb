#!/usr/bin/env ruby
#  Parse the text files to load the name statistics into the database.
#
# Got the data by copy/pasting from stats site and tweaking in Excel to give me
# Name Count lines.
#
# Usage: ruby load_data.rb *txt
#

require File.dirname(__FILE__) + '/../../../../config/environment'
require File.dirname(__FILE__) + '/../../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Scotland")
region.lat = 56.1211 
region.lng = -3.8727
region.country = "United Kingdom"
region.country_code = 'UK'
region.current_year = 2007
region.stats_name = "General Register Office for Scotland"
region.stats_url = "http://www.gro-scotland.gov.uk/statistics/publications-and-data/popular-names/index.html"
region.stats_desc = "All baby names given throughout Scotland."
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
