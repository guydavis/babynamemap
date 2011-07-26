#    Copyright 2007 Guy Davis (davis@guydavis.ca)
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

class MapController < ApplicationController
  caches_page :index, :upgrade, :region
  hide_action :search_by_name, :find_visitors_region
  
  def find_visitors_region
    location = GeoKit::Geocoders::IpGeocoder.geocode(request.remote_ip())
    if location and location.lat and location.lng
      # First try to find region based on Country and State
      @region = Region.find(:first, :conditions=> { :country_code => location.country_code,
        :region_code => location.state})          
      if not @region # Then try to find by country
        @region = Region.find_by_country_code(location.country_code)
      end           
      if not @region # Then try to find nearest to visitors location
        @region = Region.find_closest(:origin => location)
      end
    elsif not @region # If still not found, start at center of USA    
      @region = Region.find(:first, :conditions=>{ :country_code=>"US", :region_code=>'USA'})
    end    
    @lat = @region.lat
    @lng = @region.lng
  end
  
  def index
    @api_key = ENV['gmaps_api_key']
    region = Region.find(:first, :conditions=>{ :country_code=>"US", :region_code=>'USA'})
    @lat = region.lat
    @lng = region.lng    
    @regions = Region.find(:all)
    render(:layout => false) 
  end 
  
  def region
    @api_key = ENV['gmaps_api_key']
    region = Region.find(params[:id])
    @lat = region.lat
    @lng = region.lng    
    @regions = Region.find(:all)
    render(:action => 'index', :layout=>false) 
  end 
  
  def locate
    find_visitors_region
    render(:layout => false)
    return if request.xhr?
  end

  def upgrade
    render(:layout => false)
  end
  
  def search_xhr
    if not params[:search_name] # nil for search_name gets sent to main page
      redirect_to :action=>'index'
      return
    end
    search_by_name
    render(:layout => false)
    return if request.xhr?
  end
  
  def search
     if not params[:search_name] # nil for search_name gets sent to main page
      redirect_to :action=>'index'
      return
    end
    @api_key = ENV['gmaps_api_key'] # For production site.
    search_by_name
    render(:layout => false)
    return if request.xhr?
  end
    
  def search_by_name
    find_visitors_region
    @name = Name.find(:first, :conditions => {:name => params[:search_name],
       :gender => params[:gender].upcase })
    @regions = Region.find_by_sql(["select r.*, n.name, n.gender, s.name_id, s.rank, s.count, s.popularity " + \
      "from names n inner join current_stats s on n.id = s.name_id inner join regions r on " + \
      "s.region_id = r.id where n.gender = ? and n.name = ? order by s.rank", 
      params[:gender].upcase, params[:search_name]])
    @nearest_region = nil
    for region in @regions
      if @region == region
        @nearest_region = region
        break
      end
    end
    if not @nearest_region and @regions.length > 0
      @nearest_region = @regions[0]
    end
  end
  
  def auto_complete_for_search_name
    @names = Name.find_by_sql(["select * from names n where n.gender = ? and LOWER(n.name) like ? and n.is_popular order by n.name limit 10",
        (params[:gender]||"").upcase, 
        (params[:search_name]||"").downcase + '%' ])
    render :partial => 'names'
    return if request.xhr?
  end
end
