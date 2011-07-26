#!/usr/bin/env ruby
#  Parse the text files to load the name statistics into the database.
#
# Got the data by copy/pasting from stats site and tweaking in Excel to give me
# Rank. Name lines.  The stats didn't have any Count information.
#
# Usage: ruby load_data.rb *txt
#

require File.dirname(__FILE__) + '/../../../../config/environment'
require File.dirname(__FILE__) + '/../../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("England")
region.lat = 51.8765 
region.lng = -0.4614
region.country = "United Kingdom"
region.country_code = 'UK'
region.current_year = 2007
region.stats_name = "Office for National Statistics"
region.stats_url = "http://www.statistics.gov.uk/CCI/nugget.asp?ID=184"
region.stats_desc = "Top 100 names given in England (no counts...)"
region.save

# Now parse every text file that was provided.  
CurrentStat.delete_all(["region_id = ? and year < ?", region.id, region.current_year])
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
      for pair in line.scan(/(\d+)([^\d]+)/)
        load_stat_by_rank(pair[1].strip.capitalize, Integer(pair[0]), year, gender, region)
      end
    end
  end
  puts "Finished " + filename
end
