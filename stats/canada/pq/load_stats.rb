#!/usr/bin/env ruby
#
# Parse the text files to load the Alberta name statistics into the database.
# Usage: ruby load_data.rb *txt
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils'

# First get hold of the region
region = Region.find_or_initialize_by_region("Québec")
region.lat = 50.7643
region.lng = -71.4551
region.country = "Canada"
region.country_code = "CA"
region.region_code = "PQ"
region.current_year = 2006
region.stats_name = "Régie des Rentes, Québec"
region.stats_url = "http://www.rrq.gouv.qc.ca/en/enfants/"
region.stats_desc = "All baby names given in Québec."
region.save

for year in (2002..2006)
  for page in (1..20)
    filename = year.to_s + "_" + page.to_s + ".html"
    next unless File.exists? filename
    File.open(filename) do | file |
      while line = file.gets
        if line =~ /^.*bgGarcons.*$/
          @gender = "MALE"
        elsif line =~ /^.*bgFilles.*$/
          @gender = "FEMALE"
        elsif line =~ /<td>\d+<\/td><td>(.*)+<\/td><td>(\d+)<\/td>/
          name = $1.capitalize
          count = Integer($2)
          for sep in ["-", "'", " "]
            if name.index(sep)
              name = $1.split(sep).collect {|x| x.capitalize}.join(sep)
              break
            end
          end
          if (name == name.upcase) 
            puts filename + " name all upper case: " + name
          end
          if (count < 1)
            puts filename + " count less than one: " + count.to_s
          end
          if (name =~ /xx$/)  # Strip out the trailing xxxxx on some names
            name.sub!(/x+$/, '')
          end
          if not name
            puts filename + " name is nil"
          end  
          load_stat(name, count, year, @gender, region)
        end
      end
    end
    puts "Finished " + filename
  end
  if (year == region.current_year)
    for gender in ['MALE', 'FEMALE']
      calc_popularity(gender, region)
    end
  end
end