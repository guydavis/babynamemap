#!/usr/bin/env ruby
#  Parse the text files to load the BC name statistics into the database.
#
# Got the data by copy/pasting from http://www.vs.gov.bc.ca/babynames/index.html
# Text contained some single letters to mark sections and "TAKE ME BACK" links,
# but this will skip over these junk lines.
#
# Usage: ruby load_data.rb [12]*
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Victoria")
region.lat = -36.5588
region.lng = 145.4690
region.country = "Australia"
region.country_code = 'AU'
region.current_year = 2007
region.stats_name = "Department of Justice, Victoria"
region.stats_url = "http://online.justice.vic.gov.au/bdm/popular-names"
region.stats_desc = "Top 100 names given by gender."
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
      if line =~ /<TD><DIV CLASS="TRANSACTIONcell">(\d+)<\/DIV><\/TD>/
        #puts @name + " (" + $1 + ")"  
        load_stat(@name, Integer($1), year, gender, region)      
      elsif line =~ /<TD><DIV CLASS="TRANSACTIONcell">(.+)<\/DIV><\/TD>/
        @name = capitalize($1.strip)
      end
    end
  end

  if (year == region.current_year)
    calc_popularity(gender, region)
  end
  puts "Finished " + filename
end
