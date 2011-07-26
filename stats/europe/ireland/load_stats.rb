#!/usr/bin/env ruby
#
# Usage: ruby load_data.rb *csv
# Name 2006 2005 2004 2003 2002 2001 
# Aaron	31	 21	  24	 20	  15	  45
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Ireland")
region.lat = 53.4129
region.lng = -8.2439
region.country = "Ireland"
region.is_country = true
region.country_code = 'IE'
region.current_year = 2006
region.stats_name = "Central Statistics Office Ireland"
region.stats_url = "http://www.cso.ie/statistics/top_babies_names.htm"
region.stats_desc = "Top 100 baby names given by gender."
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
      #puts name + " " + count.to_s + " in " + year.to_s
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
      n = line.split(',')
      name = capitalize(n[0].strip)
      load_stat_for_year(name, n[1], 2006, gender, region)
      load_stat_for_year(name, n[2], 2005, gender, region)
      load_stat_for_year(name, n[3], 2004, gender, region)
      load_stat_for_year(name, n[4], 2003, gender, region)
      load_stat_for_year(name, n[5], 2002, gender, region)
      load_stat_for_year(name, n[6], 2001, gender, region)
    end
  end

  calc_popularity(gender, region)
  puts "Finished " + filename
end
