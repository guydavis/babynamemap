#!/usr/bin/env ruby
#  Parse the text files to load the name statistics into the database.
#
# Got the data by copy/pasting from stats site and tweaking in Excel to give me
# Rank. Name lines.  The stats didn't have any Count information.
#
# Usage: ruby load_data.rb *txt
#

require File.dirname(__FILE__) + '/../../config/environment'
require File.dirname(__FILE__) + '/../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("New Zealand")
region.current_year = 2007
region.save

CurrentStat.delete_all(["region_id = ? and year < ?", region.id, region.current_year]) 

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
    rank = 1
    while line = file.gets
      for name in line.scan(/(\w+)/)
        load_stat_by_rank(name[0].strip.capitalize, rank, year, gender, region)
        rank = rank + 1
      end
    end
  end
  puts "Finished " + filename
end
