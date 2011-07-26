#!/usr/bin/env ruby
#  Parse the text files to load the name statistics into the database.
#
# Got the data by copy/pasting from stats site and tweaking in Excel to give me
# Rank. Name lines.  The stats didn't have any Count information.  The WALES
# stats are hidden in the PDF press release each year at the bottom!
#
# Usage: ruby load_data.rb *txt
#

require File.dirname(__FILE__) + '/../../../../config/environment'
require File.dirname(__FILE__) + '/../../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Wales")
region.lat = 52.4460
region.lng = -3.6694
region.country = "United Kingdom"
region.country_code = 'UK'
region.current_year = 2007
region.stats_name = "Office for National Statistics"
region.stats_url = "http://www.statistics.gov.uk/CCI/nugget.asp?ID=184"
region.stats_desc = "Top 30 names given in Wales (no counts...)"
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
      for pair in line.scan(/(\d+)\s*([^\d]+)/)
        #puts pair[1].strip + " (" + pair[0] + ")"
        load_stat_by_rank(pair[1].strip, Integer(pair[0]), year, gender, region)
      end
    end
  end
  puts "Finished " + filename
end
