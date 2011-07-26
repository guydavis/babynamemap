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

class NameController < ApplicationController
  caches_page :browse, :pop_in_region_graph

  def details
    @name = Name.find(params[:id])
    @photo = @name.moderated_photos[-1] || nil
    @comment = @name.moderated_comments[-1] || nil
    render(:layout => false)
    return if request.xhr?
  end
  
  class Country
    attr_reader :name, :regions
    def initialize(name)
      @name = name
      @regions = []
    end
    def <<(region)
      @regions << region
    end
  end  
  
  def popularity
    @name = Name.find(params[:id])
    @regions = Region.find_by_sql(["select distinct r.* from regions r inner " + \
        "join stats s on r.id = s.region_id where s.name_id = ? order by r.country, r.region", @name.id])    
    country_groups = Hash.new
    for region in @regions
      country = country_groups[region.country_code] || Country.new(region.country)
      country << region
      country_groups[region.country_code] = country
    end
    @countries = country_groups.collect{|c| c[1] }
    @countries.sort!{|x,y| x.name <=> y.name }
    
    location = GeoKit::Geocoders::IpGeocoder.geocode(request.remote_ip())
    if params[:region_id] and (params[:region_id].to_i > 0)
      @initial_region = Region.find(params[:region_id])
    elsif location and location.lat and location.lng
      # First try to find region based on Country and State
      @initial_region = Region.find(:first, :conditions=> { :country_code => location.country_code,
        :region_code => location.state})          
      if not @initial_region  # Then try to find by country
        @initial_region  = Region.find_by_country_code(location.country_code)
      end           
      if not @initial_region  # Then try to find nearest to visitors location
        @initial_region  = Region.find_closest(:origin => location)
      end
    else  # Just showing popularity for name, no specific region, so use USA
      for region in @regions
        if region.country_code = 'US' and region.is_country
          @initial_region = region
        end  
      end
    end
    if not @initial_region # USA wasn't in returned results, just first region
      @initial_region = @regions[0]     
    end    
    render(:layout => false)
    return if request.xhr?
  end
  
  def pop_in_region_graph
    region = Region.find(params[:region_id])
    name = Name.find(params[:id])
    stats = Stat.find(:all, :conditions => { :name_id => name.id, 
        :region_id => region.id}, :order => "year")
    
    g = Gruff::Line.new('484x350')
    g.title = region.full_name
    g.no_data_message = "No name counts\nfor " + region.region + ".\nTry another region."
    g.font = File.expand_path('artwork/fonts/Vera.ttf', RAILS_ROOT)
    g.theme = g.theme_37signals()
    
    if (stats.size > 0)
      min_year = stats[0].year
      max_year = stats[-1].year
      labels_every = (max_year - min_year) / 8  # Show around 5 labels  
      data = Array.new
      g.labels = Hash.new
      curStatIdx = 0
      for year in (min_year..max_year)
        if (labels_every == 0) or (year.modulo(labels_every) == 0) or (year == min_year)
          g.labels[data.length] = year.to_s
        end
        if (curStatIdx < stats.size) and (stats[curStatIdx].year == year)
          data << stats[curStatIdx].count
          curStatIdx = curStatIdx + 1
        else
          data << nil
        end
      end
    end
    if (name.gender == "MALE")
      g.data("Baby boys named " + name.name, data)
    else
      g.data("Baby girls named " + name.name, data)
    end
    send_data(g.to_blob, 
      :disposition => 'inline', 
      :type => 'image/png', 
      :filename => "pop_graph.png")
  end

  def compare_graph
    g = Gruff::Line.new('484x350')
    g.font = File.expand_path('artwork/fonts/Vera.ttf', RAILS_ROOT)
    g.theme = g.theme_37signals()
    region = Region.find(params[:region_id]||3)
    g.title = region.full_name
    g.no_data_message = "Names not found in\n" + region.region + ".\nPlease try again."

    clauses = Array.new
    for boy in (params[:boys]||"").split(',')
      name = boy.strip.downcase.gsub(/'/, "''")  
      clauses << "(lower(name) = '" + name + "' and gender = 'MALE')" 
    end
    for girl in (params[:girls]||"").split(',') 
      name = girl.strip.downcase.gsub(/'/, "''") 
      clauses << "(lower(name) = '" + name + "' and gender = 'FEMALE')"
    end

    names = Array.new
    stats = Array.new
    if (clauses.size <= 0) # No names submitted
      g.no_data_message = "Please enter some\n names below."
    elsif (clauses.size > 10) # Only allow 10 names max 
      g.no_data_message = "Too many names.\nOnly eight allowed."
    else # Reasonable amount of names provided
      names = Name.find_by_sql("select * from names where " + clauses.join(" or ") + " order by id")
      stats = Stat.find_by_sql(["select * from stats where region_id = ? and name_id in (" + \
              names.collect{|n| n.id.to_s}.join(',') + ") order by year, name_id", region.id])
    end

    if (stats.size > 0)
      data = Hash.new
      for name in names
        data[name.id] = Array.new
      end 

      min_year = stats[0].year
      max_year = stats[-1].year
      labels_every = (max_year - min_year) / 8  # Show around 5 labels  
      g.labels = Hash.new
      for year in (min_year..max_year)
        if (labels_every == 0) or (year.modulo(labels_every) == 0) or (year == min_year)
          g.labels[year - min_year] = year.to_s
        end
      end

      stat_idx = 0
      for year in (min_year..max_year)
        for name in names
          value = nil
          if (stat_idx < stats.size)
	    stat = stats[stat_idx]
	    if (year == stat.year and name.id == stat.name_id)
              value = stat.count
              stat_idx = stat_idx + 1
            end
          end
          data[name.id] << value
        end
      end
      # Gruff only provides the first seven colors
      g.add_color('#66FFFF')
      g.add_color('#7c7c7c')
      g.add_color('#003300')
      for name in names
        label = name.name
        name_count = 0
        for n in names
          if (n.name == label)
            name_count = name_count + 1
          end
        end
        if (name_count > 1)
          label = name.name + " (" + name.gender[0..0].upcase + ")"
        end
        g.data(label, data[name.id])
      end
    end
    send_data(g.to_blob,
      :disposition => 'inline',
      :type => 'image/png',
      :filename => "compare_graph.png")
  end
  
  def photos
    @name = Name.find(params[:id])
    @visitor = Visitor.find_or_initialize_by_ip_addr(request.remote_ip())
    render(:layout => false)
    return if request.xhr?
  end
  
  def add_photo
    @name = Name.find(params[:id])
    @visitor = Visitor.find_or_create_by_ip_addr(request.remote_ip())
    if simple_captcha_valid?
      @photo = Photo.new(params["photo"])
      @photo.visitor = @visitor
      @photo.name = @name
      if not @photo.save
        flash[:error] = "Please provide a photo file when uploading."
      end
    else 
      @captcha_failed = true
      flash[:error] = "The image text you entered did not match.  Please try again."
    end
    responds_to_parent do
      render :update do |page|
        if @captcha_failed
          page << "new Ajax.Request('/name/captcha', { asynchronous:true, " + 
            "evalScripts:true,onFailure:function(request){showXhrFailure(request)}, " +  
            "onSuccess:function(request){$('captcha_div').update(request.responseText)}});"
        end
        if flash[:error]
          page.replace_html 'photo_form_errors', flash[:error]
          page.show 'photo_form_errors'
        else
          page.hide 'photo_form_errors' 
          page.hide 'photo_form'
          page.replace_html  'add_photo_div', 
            "Thanks! Your photo will be displayed after moderation."
        end
      end
    end
  end
  
  def comments
    @name = Name.find(params[:id])
    @visitor = Visitor.find_or_initialize_by_ip_addr(request.remote_ip())
    render(:layout => false)
    return if request.xhr?
  end
  
  def captcha
    render(:partial => "captcha")
    return if request.xhr?
  end
  
  def compare
    regions = Region.find :all
    country_groups = Hash.new
    for region in regions
      country = country_groups[region.country_code] || Country.new(region.country)
      country << region
      country_groups[region.country_code] = country
    end
    @countries = country_groups.collect{|c| c[1] }
    @countries.sort!{|x,y| x.name <=> y.name }
    location = GeoKit::Geocoders::IpGeocoder.geocode(request.remote_ip())
    if location and location.lat and location.lng
      # First try to find region based on Country and State
      @initial_region = Region.find(:first, :conditions=> { :country_code => location.country_code, :region_code => location.state})          
      if not @initial_region  # Then try to find by country
        @initial_region  = Region.find_by_country_code(location.country_code)
      end           
      if not @initial_region  # Then try to find nearest to visitors location
        @initial_region  = Region.find_closest(:origin => location)
      end
    end   
    if not @initial_region # Just use the USA as last resort
      @initial_region = Region.find_by_id(3)    
    end
    @boys = Name.find_by_sql(["select n.* from names n inner join current_stats cs on n.id = cs.name_id where cs.region_id = ? and n.gender = 'MALE' order by cs.rank limit 3", @initial_region.id]).collect{|n|CGI::escape(n.name)}.join(', ')  
    @girls = Name.find_by_sql(["select n.* from names n inner join current_stats cs on n.id = cs.name_id where cs.region_id = ? and n.gender = 'FEMALE' order by cs.rank limit 3", @initial_region.id]).collect{|n|CGI::escape(n.name)}.join(', ')   
    render(:layout => false)
    return if request.xhr?
  end
  
  def add_comment
    @name = Name.find(params[:id])
    @visitor = Visitor.find_or_create_by_ip_addr(request.remote_ip())
    if not params[:name] or params[:name].strip.size == 0
      flash[:error] = "Please provide your name."
    elsif not params[:comment] or params[:comment].strip.size == 0
      flash[:error] = "Please provide a comment."
    elsif simple_captcha_valid?
      @visitor.name = params[:name]
      @visitor.save
      @comment = Comment.new
      @comment.visitor = @visitor
      @comment.comment = params[:comment]
      @comment.save
      @name.comments << @comment
    else 
      @captcha_failed = true
      flash[:error] = "The image text you entered did not match.  Please try again."
    end
    render(:layout => false)
    return if request.xhr?
  end
  
  def browse
    @gender = params[:gender].upcase
    @letter = params[:letter]
    if @gender == "MALE"
      gender_type = "Boys'"
    else
      gender_type = "Girls'"
    end
    @subtitle = "Browsing Popular " + gender_type + " Names"
  end
  
  # Called from the browse page to get the names list data to populate the grid.
  def browse_data
    gender = params[:gender].upcase
    letter_filter = ""
    if params[:letter] =~ /[A-Z]/
      letter_filter = " and lower(n.name) like '" + $&.downcase + "%'"
    end
    start = (params[:start] || 1).to_i      
    size = (params[:limit] || 20).to_i 
    sort_col = (params[:sort] || 'name')
    sort_dir = (params[:dir] || 'ASC')
    page = ((start/size).to_i)+1
    total = Name.count_by_sql(["select count(*) from names n where n.is_popular and n.gender = ?" + letter_filter, 
        gender])
    names = Name.find_by_sql(["select * from names n where n.is_popular and n.gender = ?" + letter_filter + " order by " + \
        sort_col + " " + sort_dir + " limit ?,?", 
        gender, start, size])
    return_data = Hash.new()      
    return_data[:Total] = total      
    return_data[:Names] = names.collect{|n| {:id=>n.id, :name=>n.name, 
        :rating_avg=>n.rating_avg} }      
    render :text=>return_data.to_json, :layout=>false
    return if request.xhr?
  end
  
  def rate
    @name = Name.find(params[:id])
    @visitor = Visitor.find_or_create_by_ip_addr(request.remote_ip())
    @name.rate Integer(params[:rating]), @visitor
    render :partial => 'name_rating'
    return if request.xhr?
  end

  def opensearch_complete
    names = Name.find(:all, 
      :conditions => [ 'gender = ? and LOWER(name) LIKE ?', 
        params[:gender].upcase, 
        params[:name].downcase + '%' ], 
      :order => 'name ASC',
      :limit => 10)
    suggestions = Array.new
    for name in names
      suggestions << name.name 
    end
    result = Array.new
    result << params[:name]
    result << suggestions
    render :text=>result.to_json, :layout=>false
    return if request.xhr?
  end
  
  # List the name info for an ID
  def api_show
    name = Name.find(params[:id])
    respond_to do |format|
      format.json { render :json => name.to_json(:only => [:name,:gender,:rating_avg ])}
      format.xml  { render :xml => name.to_xml(:only => [:name,:gender,:rating_avg ])}
    end
  end
  
  # List the regions that a name is used in a given year 
  def api_where
    regions = Stat.connection.select_all("select distinct(region_id) from stats where year = " + 
      (params[:year]||0).to_i.to_s + " and name_id = " + (params[:id]||0).to_i.to_s)
    respond_to do |format|
      format.json { render :json => regions.to_json(:only => [:id])}
      format.xml  { render :xml => regions.to_xml(:except => [:id])}
    end
  end
  
  # Search for an ID given a name and gender
  def api_search
    name = Name.find(:first, :conditions=> { :name=>params[:name], :gender=>params[:gender] } )
    respond_to do |format|
      format.json { render :json => name.to_json(:only => [:id ])}
      format.xml  { render :xml => name.to_xml(:only => [:id ])}
    end
  end
end
