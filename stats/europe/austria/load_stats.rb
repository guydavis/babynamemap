#!/usr/bin/env ruby
#
# Usage: ruby load_data.rb *html
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Austria")
region.lat = 47.5162
region.lng = 14.5501
region.country = "Austria"
region.country_code = 'AT'
region.current_year = 2006
region.stats_name = "Statistik Austria"
region.stats_url = "http://www.statistik.at/dynamic/web_de/statistiken/bevoelklerung/geburten/haeufigste_vornamen/025096"
region.stats_desc = "Top 10 popular baby names."
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
    for gender in ['MALE', 'FEMALE']
      calc_popularity(gender, region)
    end
  end
  puts "Finished " + filename
end
