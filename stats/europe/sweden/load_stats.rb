#!/usr/bin/env ruby
#
# Usage: ruby load_data.rb *csv
# Data looked like:  - means less than 10, so skip
# Name 2006 2005 2004 2003 2002 2001 2000 1999 1998
# Aaron	31	 21	  24	 20	  15	  -	  12	  -	  -
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Sweden")
region.lat = 61.8976
region.lng = 15.7324
region.country = "Sweden"
region.country_code = 'SE'
region.current_year = 2007
region.stats_name = "Statistiska centralbyrån"
region.stats_url = "http://www.scb.se/BE0001-EN"
region.stats_desc = "All baby names given more than 10 times."
region.save

def parseInt(s)
  s = s.gsub(/,/, '')
  begin
    Integer(s)
  rescue
    nil
  end
end

def load_stat_for_year(name, count_str, year, gender, region)
  if count_str
    count = parseInt(count_str)
    if count
      load_stat(name,count, year, gender, region)
    end
  end
end

# Now parse every text file that was provided.  
for filename in ARGV
  if filename =~ /boy/i
    gender = "MALE"
  else
    gender = "FEMALE"
  end
  File.open(filename) do | file |
    while line = file.gets
      n = line.split
      name = n[0].strip
      load_stat_for_year(name, n[1], 2007, gender, region)
    end
  end

  calc_popularity(gender, region)
  puts "Finished " + filename
end
