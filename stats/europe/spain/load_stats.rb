#!/usr/bin/env ruby
#
# Usage: ruby load_data.rb *html
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Spain")
region.lat = 40.4637
region.lng = -3.7492
region.country = "Spain"
region.country_code = 'ES'
region.current_year = 2006
region.stats_name = "Instituto Nacional de Estadistica"
region.stats_url = "http://www.ine.es/en/daco/daco42/nombyapel/nombyapel_en.htm"
region.stats_desc = "Top 150 baby names given by gender."
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
     for pair in line.scan(/^([^\d]+)([\d,]+)$/)
       name = capitalize(pair[0].strip)
       count = Integer(pair[1].gsub(/,/,''))
       load_stat(name, count, year, gender, region)
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
