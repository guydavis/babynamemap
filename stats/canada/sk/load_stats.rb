#!/usr/bin/env ruby
#
# Usage: ruby load_data.rb *html
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Saskatchewan")
region.lat = 54.5007
region.lng = -105.6842
region.region_code = 'SK'
region.country = "Canada"
region.country_code = 'CA'
region.current_year = 2007
region.stats_name = "Vital Statistics, Government of Saskatchewan"
region.stats_url = "http://www.health.gov.sk.ca/popular-baby-names"
region.stats_desc = "Top 20 given names by gender."
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
