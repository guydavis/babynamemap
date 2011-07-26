#!/usr/bin/env ruby
#
# Just copy the goofy table from Firefox into OO spreadsheet.  Delete unwanted columns.
# Then copy just "Name\tCount" columns into a text file. 
# 
# Usage: ruby load_data.rb 2007_boys.txt 2007_girls.txt
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Western Australia")
region.lat = -24.4133
region.lng = 121.0790
region.country = "Australia"
region.country_code = 'AU'
region.current_year = 2007
region.stats_name = "Department of the Attorney General"
region.stats_url = "http://www.justice.wa.gov.au/B/babyname.aspx?uid=1698-5030-2186-7313"
region.stats_desc = "Top 50 baby names given by gender."
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
      for pair in line.scan(/^([^\d]+)(\d+)$/)
        #puts pair[0].strip + ' (' + pair[1] + ')'
        load_stat(pair[0].strip, Integer(pair[1]), year, gender, region)
      end
    end
  end

  if (year == region.current_year)
    calc_popularity(gender, region)
  end
  puts "Finished " + filename
end
