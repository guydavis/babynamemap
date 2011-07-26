#!/usr/bin/env ruby
#
# Parse the text files to load the Alberta name statistics into the database.
# Just open the PDFs in Preview, Select All text, paste into Textmate and save as .txt.
# Usage: ruby load_data.rb *txt
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Alberta")
region.lat = 54.5010
region.lng = -114.9999
region.country = "Canada"
region.country_code = "CA"
region.region_code = "AB"
region.current_year = 2008
region.stats_name = "Vital Statistics, Government of Alberta"
region.stats_url = "http://www.servicealberta.gov.ab.ca/807.cfm"
region.stats_desc = "All baby names given in Alberta."
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
      for pair in line.scan(/^(\d+)(.*)$/)
        #puts pair[1].strip + ' (' + pair[0] + ')'
        load_stat(pair[1].strip, Integer(pair[0]), year, gender, region)
      end
    end
  end

  if (year == region.current_year)
    calc_popularity(gender, region)
  end
  puts "Finished " + filename
end
