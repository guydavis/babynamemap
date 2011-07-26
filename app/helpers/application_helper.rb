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

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def popular_names(gender, remote_search)
    names = Name.find_by_sql(["select distinct n.* from names n inner join " + \
      "current_stats s on n.id = s.name_id and n.gender = ? and " + \
      "s.popularity = 0 order by rand() limit 10", gender])
    names.sort!{|x,y| x.name <=> y.name }
    if remote_search
      names.collect{ |n| link_to(h(n.name), "javascript:remoteSearch('" + \
        escape_javascript(n.name) + "', '" + n.gender + "')") }.join(", ")
    else
      names.collect{ |n| link_to(h(n.name), "javascript:showNameWindow('" + \
        escape_javascript(n.name) + "', " + n.id.to_s + ", 'details')") }.join(", ")
    end
  end
  
  def boy_or_girl(gender)
    if gender.upcase == "MALE"
      return "Boy"
    else
      return "Girl"
    end
  end
  
  def format_date(date, use_time = false)
      if use_time == true
          ampm = date.strftime("%p").downcase
          new_date = date.strftime("%b. %d, %Y at %I:%M " + ampm)
      else
          new_date = date.strftime("%b. %d, %Y")
      end
  end 
end
