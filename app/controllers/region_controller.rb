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

class RegionController < ApplicationController
  caches_page :popular, :info_win_max
  
  def popular
    @region = Region.find(params[:region_id])
    @gender = params[:gender].upcase
    @letter = params[:letter]
    if @gender == "MALE"
      gender_type = "Boys'"
    else
      gender_type = "Girls'"
    end
    @subtitle = "Popular " + gender_type + " Names in " + @region.full_name \
      + " for " + @region.current_year.to_s
  end
  
  def info_win_max
    @region = Region.find(params[:id])
    render(:layout=>false)
  end
  
  # Called from the region page to get the names list data to populate the grid.
  def popular_data
    region = Region.find_by_id(params[:region_id].to_i)
    gender = params[:gender]
    letter_filter = ""
    if params[:letter] =~ /[A-Z]/
      letter_filter = " and n.name like '" + $& + "%'"
    end
    start = (params[:start] || 1).to_i      
    size = (params[:limit] || 20).to_i 
    sort_col = (params[:sort] || 'rank')
    sort_dir = (params[:dir] || 'ASC')
    page = ((start/size).to_i)+1
    total = Name.count_by_sql(["select count(*) from names n inner join current_stats s " +\
      " on n.id = s.name_id where s.region_id = ? and n.gender = ?" + letter_filter, region.id, gender])
    names = Name.find_by_sql(["select n.*, s.rank, s.count from names n inner join current_stats s " + \
      " on n.id = s.name_id where s.region_id = ? and n.gender = ?" + letter_filter + " order by " + \
      sort_col + " " + sort_dir + " limit ?,?", region.id, gender, start, size])
    return_data = Hash.new()      
    return_data[:Total] = total      
    return_data[:Names] = names.collect{|n| {:id=>n.id, :rank=>n.rank,
      :name=>n.name, :count=>n.count, :rating_avg=>n.rating_avg }}     
    render :text=>return_data.to_json, :layout=>false
    return if request.xhr?
  end
  
  # List the regions for a data API call
  def api_list
    regions = Region.find :all
    respond_to do |format|
      format.json { render :json => regions.to_json(:except => [:has_icon,:is_country ])}
      format.xml  { render :xml => regions.to_xml(:except => [:has_icon,:is_country ])}
    end
  end
  
  # List the currently popular names in a region
  def api_years
    years = Stat.connection.select_all("select distinct(year) from stats where region_id = " + 
    (params[:id]||0).to_i.to_s)
    respond_to do |format|
      format.json { render :json => years}
      format.xml  { render :xml => years}
    end
  end
  
  # List the popular names in a region in past years
  def api_stats
    stats = Stat.find(:all, :conditions=> { :region_id=>params[:id], :year=>params[:year]},
       :order=>'count', :offset=>(params[:offset]||0), :limit=>100)
    respond_to do |format|
      format.json { render :json => stats.to_json(:except => [:id])}
      format.xml  { render :xml => stats.to_xml(:except => [:id])}
    end
  end
end
