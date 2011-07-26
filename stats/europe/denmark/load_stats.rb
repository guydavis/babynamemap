#!/usr/bin/env ruby
#
# Usage: ruby load_data.rb *txt
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Denmark")
region.lat = 56.2639
region.lng = 9.5018
region.country = "Denmark"
region.country_code = 'DK'
region.current_year = 2006
region.stats_name = "Danmarks Statstik"
region.stats_url = "http://www.dst.dk/"
region.stats_desc = "Top 50 baby names given by gender."
region.save

# ************* JUST TO FIX MY FSCKED INITIAL LOAD **************
Stat.delete_all(["region_id = ?", region.id])
CurrentStat.delete_all(["region_id = ?", region.id])

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
        #puts pair[0].strip + " (" + pair[1] + ")"
        load_stat(pair[0].strip, Integer(pair[1]), year, gender, region)
      end
    end
  end

  if (year == region.current_year)
    calc_popularity(gender, region)
  end
  puts "Finished " + filename
end
