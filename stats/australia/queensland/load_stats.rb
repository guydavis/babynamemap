#!/usr/bin/env ruby
#  Parse the text files to load the name statistics into the database.
#
# Got the data by copy/pasting from stats site and tweaking in Excel to give me
# Name Count lines.
#
# Usage: ruby load_data.rb *txt
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Queensland")
region.lat = -21.9023 
region.lng = 144.0088
region.country = "Australia"
region.country_code = 'AU'
region.current_year = 2006
region.stats_name = "Department of Justice and Attorney General, Queensland Government"
region.stats_url = "http://www.justice.qld.gov.au/news/names2006.htm"
region.stats_desc = "Top 100 names given for each gender."
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
      for pair in line.scan(/(\d+)([^\d]+)/)
        load_stat(pair[1].strip, Integer(pair[0]), year, gender, region)
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
