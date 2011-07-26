#!/usr/bin/env ruby
#
# Parse the text files to load the Alberta name statistics into the database.
# Usage: ruby load_data.rb *html
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("New South Wales")
region.lat = -33.2295
region.lng = 146.3159
region.country = "Australia"
region.country_code = "AU"
region.region_code = "NSW"
region.current_year = 2007
region.stats_name = "New South Wales Registry of Births, Deaths and Marriages "
region.stats_url = "http://www.bdm.nsw.gov.au/births/popularBabyNames.htm"
region.stats_desc = "Top 100 names given throughout the state."
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
      for pair in line.scan(/^<tr><td>(.*)<\/td><td>(\d+)<\/td><\/tr>$/)
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
