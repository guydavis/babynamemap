#!/usr/bin/env ruby
#  Parse the HTML files to load the US name statistics into the database.
#
# Usage: ruby load_data.rb
#

require File.dirname(__FILE__) + '/../../config/environment'
require File.dirname(__FILE__) + '/../load_utils'

regions = ['USA','AK','AL','AR','AZ','CA','CO','CT','DC','DE','FL','GA','HI','IA','ID','IL','IN','KS','KY','LA','MA','MD','ME','MI','MN','MO','MS','MT','NC','ND','NE','NH','NJ','NM','NV','NY','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VA','VT','WA','WI','WV','WY']
region_names = { 'USA' => 'United States', 'AK'=>'Alaska', 'AL'=>'Alabama', 'AR'=>'Arkansas', 'AZ'=>'Arizona', 'CA'=>'California', 'CO'=>'Colorado', 'CT'=>'Connecticut', 'DC'=>'District of Columbia', 'DE'=>'Delaware', 'FL'=>'Florida', 'GA'=>'Georgia', 'HI'=>'Hawaii', 'IA'=>'Iowa', 'ID'=>'Idaho', 'IL'=>'Illinois', 'IN'=>'Indiana', 'KS'=>'Kansas', 'KY'=>'Kentucky', 'LA'=>'Louisiana', 'MA'=>'Massachusetts', 'MD'=>'Maryland', 'ME'=>'Maine', 'MI'=>'Michigan', 'MN'=>'Minnesota', 'MO'=>'Missouri', 'MS'=>'Mississippi', 'MT'=>'Montana', 'NC'=>'North Carolina', 'ND'=>'North Dakota', 'NE'=>'Nebraska', 'NH'=>'New Hampshire', 'NJ'=>'New Jersey', 'NM'=>'New Mexico', 'NV'=>'Nevada', 'NY'=>'New York', 'OH'=>'Ohio', 'OK'=>'Oklahoma', 'OR'=>'Oregon', 'PA'=>'Pennsylvania', 'RI'=>'Rhode Island', 'SC'=>'South Carolina', 'SD'=>'South Dakota', 'TN'=>'Tennessee', 'TX'=>'Texas', 'UT'=>'Utah', 'VA'=>'Virginia', 'VT'=>'Vermont', 'WA'=>'Washington', 'WI'=>'Wisconsin', 'WV'=>'West Virginia', 'WY'=>'Wyoming' }
region_lats = { 'USA' => '39.828175', 'AK'=>'61.2105', 'AL'=>'32.6144', 'AR'=>'34.7519', 'AZ'=>'34.1679', 'CA'=>'37.2719', 'CO'=>'38.9979', 'CT'=>'41.5007,', 'DC'=>'38.8938', 'DE'=>'39.1453', 'FL'=>'28.5377', 'GA'=>'32.6783', 'HI'=>'21.3047', 'IA'=>'41.9382', 'ID'=>'43.6814', 'IL'=>'39.7393', 'IN'=>'39.7662', 'KS'=>'38.4981', 'KY'=>'37.8224', 'LA'=>'30.2336', 'MA'=>'42.3586', 'MD'=>'39.2906', 'ME'=>'45.2542', 'MI'=>'43.5972', 'MN'=>'46.4419', 'MO'=>'38.3046', 'MS'=>'32.5771', 'MT'=>'46.6795', 'NC'=>'35.2139', 'ND'=>'47.4678', 'NE'=>'41.5008', 'NH'=>'44.0012', 'NJ'=>'40.0724', 'NM'=>'34.1661', 'NV'=>'38.5019', 'NY'=>'42.7466', 'OH'=>'40.3651', 'OK'=>'35.3091', 'OR'=>'44.1431', 'PA'=>'41.1099', 'RI'=>'41.5387', 'SC'=>'33.6233', 'SD'=>'44.2126', 'TN'=>'35.8307', 'TX'=>'31.1689', 'UT'=>'39.4997', 'VA'=>'38.0033', 'VT'=>'43.8717', 'WA'=>'46.9970', 'WI'=>'44.9010', 'WV'=>'38.9197', 'WY'=>'43.0003' }
region_lngs = { 'USA' => '-98.5795', 'AK'=>'-154.9898', 'AL'=>'-86.6807', 'AR'=>'-92.1305', 'AZ'=>'-111.9307', 'CA'=>'-119.2702', 'CO'=>'-105.5510', 'CT'=>'-72.7575', 'DC'=>'-77.0147', 'DE'=>'-75.4030', 'FL'=>'-81.3774', 'GA'=>'-83.2228', 'HI'=>'-157.8576', 'IA'=>'-93.3899', 'ID'=>'-114.3652', 'IL'=>'-89.3198', 'IN'=>'-86.4411', 'KS'=>'-98.3202', 'KY'=>'-85.7680', 'LA'=>'-92.0927', 'MA'=>'-71.0567', 'MD'=>'-76.6096', 'ME'=>'-69.0125', 'MI'=>'-84.7682', 'MN'=>'-93.3616', 'MO'=>'-92.4366', 'MS'=>'-89.8737', 'MT'=>'-110.0445', 'NC'=>'-79.8909', 'ND'=>'-100.3019', 'NE'=>'-99.6809', 'NH'=>'-71.6276', 'NJ'=>'-74.7286', 'NM'=>'-106.0261', 'NV'=>'-117.0226', 'NY'=>'-75.7700', 'OH'=>'-82.6695', 'OK'=>'-98.7170', 'OR'=>'-120.5148', 'PA'=>'-77.6047', 'RI'=>'-71.4534', 'SC'=>'-80.9474', 'SD'=>'-100.2471', 'TN'=>'-85.9787', 'TX'=>'-100.0772', 'UT'=>'-111.5473', 'VA'=>'-79.4585', 'VT'=>'-72.4518', 'WA'=>'-120.5487', 'WI'=>'-89.5695', 'WV'=>'-80.1817', 'WY'=>'-107.5541' }

for region_code in regions
  region = Region.find_or_initialize_by_region_code(region_code)
  region.lat = region_lats[region_code]
  region.lng = region_lngs[region_code]
  region.country = "USA"
  region.country_code = 'US'
  region.region = region_names[region_code]
  region.stats_name = "Social Security Administration"
  region.stats_url = "http://www.ssa.gov/OACT/babynames/"
  region.current_year = 2008
  if region_code == 'USA'
    region.stats_desc = "Top 1000 names given throughout the entire United States."
  else
    region.stats_desc = "Top 100 names given throughout the state."
  end
  region.save
  
  # Uncomment this to only update the regions and not load data
  #next 
  
  for year in (2008..2008)
    filename = region_code + "/" + year.to_s + ".html"
    next unless File.exists? filename
    File.open(filename) do | file |
      while line = file.gets
        if region_code == 'USA'  # Data for entire US is formatted differently
          if line =~ /^ <td>\d+<\/td> <td>(.*)<\/td><td>([\d,]+)<\/td>$/
            load_stat($1.strip, Integer($2.gsub(/,/, '')), year, "MALE", region)
          elsif line =~ /^<td>([\d\,]+)<\/td>$/
            load_stat(@female_name, Integer($1.gsub(/,/, '')), year, "FEMALE", region)
          elsif line =~ /^ <td>(.*)<\/td>$/
            @female_name = $1.strip
          end
        else # All State data is formatted the same
          if line =~ /^    <td align="center">(.*)<\/td>$/
            @kid_name = $1.strip
          elsif line =~ /^    <td>([\d\,]+)<\/td>$/
            #puts (@kid_name + " " + $1.gsub(/,/, '') + " MALE")  
	    load_stat(@kid_name, Integer($1.gsub(/,/, '')), year, "MALE", region)
          elsif line =~ /^    <td>([\d\,]+)<\/td><\/tr>$/
            #puts (@kid_name + " " + $1.gsub(/,/, '') + " FEMALE") 
            load_stat(@kid_name, Integer($1.gsub(/,/, '')), year, "FEMALE", region)
          end
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
