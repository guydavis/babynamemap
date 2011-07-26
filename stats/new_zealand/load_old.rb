#!/usr/bin/env ruby
#  Parse the text files to load the name statistics into the database.
#
# Got the data by copy/pasting from stats site and tweaking in Excel to give me
# Name Count lines.
#
# Usage: ruby load_data.rb *txt
#

require File.dirname(__FILE__) + '/../../config/environment'
require File.dirname(__FILE__) + '/../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("New Zealand")
region.lat = -41.6893
region.lng = 173.9136
region.country = "New Zealand"
region.country_code = 'NZ'
region.current_year = 2006
region.stats_name = "The Department of Internal Affairs"
region.stats_url = "http://www.dia.govt.nz/diawebsite.nsf/wpg_URL/Services-Births-Deaths-and-Marriages-Most-Popular-First-Names?OpenDocument"
region.stats_desc = "Top 30 names given for each gender."
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
  puts "Finished " + filename
end
