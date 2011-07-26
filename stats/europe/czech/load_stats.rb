#!/usr/bin/env ruby
#  
# Copy the HTML table text into a spreadsheet and push into txt file.
#
# Usage: ruby load_data.rb 200*
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Czech Republic")
region.lat = 49.8175
region.lng = 15.4730
region.country = "Czech Republic"
region.is_country = true
region.country_code = 'CZ'
region.current_year = 2006
region.stats_name = "Czech Statistical Office"
region.stats_url = "http://www.czso.cz/csu/redakce.nsf/i/nejcastejsi_jmena_deti_v_lednu_2006"
region.stats_desc = "Top ten names by gender given each year."
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
