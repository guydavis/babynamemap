#!/usr/bin/env ruby
#
# Parse Chilean stats for all years 
# Usage: ruby parse.rb START_YEAR LAST_YEAR
#

require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../../load_utils.rb'

def unescapeHTML(str)
  str.gsub(/&Aacute;/,'Á').gsub(/&Eacute;/, 'É').gsub(/&Iacute;/,'Í').gsub(/&Oacute;/,'Ó') \
   .gsub(/&aacute;/, 'á').gsub(/&eacute;/, 'é').gsub(/&iacute;/,'í').gsub(/&oacute;/,'ó');
end

# First get hold of the region
region = Region.find_or_initialize_by_region("Chile")
region.lat = -35.6751
region.lng = -71.5430
region.country = "Chile"
region.country_code = 'CL'
region.current_year = 2006
region.stats_name = "Servicio de Registro Civil e Identificacion"
region.stats_url = "http://www.registrocivil.cl/Servicios/Estadisticas/Archivos/NombresComunes/2006.html"
region.stats_desc = "Top 100 names given by gender."
region.save

for year in (Integer(ARGV[0])..Integer(ARGV[1]))
  File.open(year.to_s + ".html") do | file |
    while line = file.gets
      if line =~ /(\d+)\.(\d+) inscritos/
        @total = Integer($1 + $2)
      end
    end
  end
  
  gender = 'MALE'
  File.open(year.to_s + ".html") do | file |
    while line = file.gets
      if line =~ /<td.*ALIGN="*LEFT"*>(.*)<\/td>/i
        @name = capitalize(unescapeHTML($1))
      elsif line =~ /<td.*>([\d,]{4})%<\/td>/i 
	percent = Float($1.gsub(/,/, '.'))
        count = Integer(percent * @total / 100)
        #puts @name + " (" + count.to_s + ") - " + gender 
        load_stat(@name, count, year, gender, region)
        if gender == "MALE"
          gender = "FEMALE"
        else
          gender = "MALE"
        end
      end
    end
  end

  if (year == region.current_year)
    for gender in ['MALE', 'FEMALE']
      calc_popularity(gender, region)
    end
  end
  puts "Finished year: " + year.to_s + " with total births: " + @total.to_s
end
