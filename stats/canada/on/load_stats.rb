#!/usr/bin/env ruby
#
# Usage: ruby load_data.rb *txt
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Ontario")
region.lat = 49.2679
region.lng = -84.7449
region.country = "Canada"
region.country_code = 'CA'
region.region_code = 'ON'
region.current_year = 2003
region.stats_name = "Office of the Registrar General"
region.stats_url = "http://www.ServiceOntario.ca"
region.stats_desc = "Top 100 baby names by gender."
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
        load_stat(capitalize(pair[0].strip), Integer(pair[1]), year, gender, region)
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
