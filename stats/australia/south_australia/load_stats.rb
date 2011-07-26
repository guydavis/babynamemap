#!/usr/bin/env ruby
#
# Usage: ruby load_data.rb 2007*
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("South Australia")
region.lat = -32.0289
region.lng = 135.0020
region.country = "Australia"
region.country_code = 'AU'
region.current_year = 2007
region.stats_name = "Office of Consumer and Business Affairs"
region.stats_url = "http://www.ocba.sa.gov.au/bdm/babynames.html"
region.stats_desc = "All baby names given by gender."
region.save

# Now parse every text file that was provided.  
for filename in ARGV
  filename =~ /^[0-9]{4}/
  year = Integer($&) # Get year from previous regexp on filename
  if filename =~ /female/i
    gender = "FEMALE"
  else
    gender = "MALE"
  end
  
  File.open(filename) do | file |
    while line = file.gets
      for pair in line.scan(/^<tr><td align="left" bgcolor="#..ccff" width="200">([^\d]+)<\/td><td align="right" valign="top" bgcolor="#..ccff" width="35">(\d+)<\/td><\/tr>$/)
        #puts capitalize(pair[0].strip) + " (" + pair[1] + ")"
        load_stat(capitalize(pair[0].strip), Integer(pair[1]), year, gender, region)
      end
    end
  end

  if (year == region.current_year)
    calc_popularity(gender, region)
  end
  puts "Finished " + filename
end
