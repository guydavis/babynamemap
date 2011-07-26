#!/usr/bin/env ruby
#  Parse the text files to load the name statistics into the database.
#
# Got the data by copy/pasting from stats site and tweaking in Excel to give me
# Name Count lines.
#
# Usage: ruby load_data.rb *txt
#

require File.dirname(__FILE__) + '/../../../../config/environment'
require File.dirname(__FILE__) + '/../../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Northern Ireland")
region.lat = 54.5784
region.lng = -6.8884
region.country = "United Kingdom"
region.country_code = 'UK'
region.current_year = 2006
region.stats_name = "Northern Ireland Statistics and Research Agency"
region.stats_url = "http://www.nisra.gov.uk/demography/default.asp?cmsid=20_45_53&cms=demography_Publications_Baby+Names&release="
region.stats_desc = "Top 100 baby names by gender given in Northern Ireland."
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
