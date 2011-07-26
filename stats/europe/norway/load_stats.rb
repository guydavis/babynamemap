#!/usr/bin/env ruby
#
# Usage: ruby load_data.rb *csv
# Data looked like:  : means less than 4, so skip
# Name 2006 2005 2004 2003 2002 2001 2000 1999 1998 1997
# Aaron	31	 21	  24	 20	  15	  :	  12	  :	  :    5
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Norway")
region.lat = 60.4720
region.lng = 8.4689
region.country = "Norway"
region.country_code = 'NO'
region.current_year = 2007
region.stats_name = "Statistisk sentralbyrå"
region.stats_url = "http://www.ssb.no/english/subjects/00/navn_en/"
region.stats_desc = "Names given more than 4 times per year and at least 10 times once since 1997."
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
      #puts name + " (" + count.to_s + ")"
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
      name = capitalize(n[0].strip)
      load_stat_for_year(name, n[1], 2007, gender, region)
    end
  end

  calc_popularity(gender, region)
  puts "Finished " + filename
end
