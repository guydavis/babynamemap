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

module MapHelper
  def map_icon_path(popularity)
    path = "/images/map_pins/"
    case Integer(popularity)
    when 0
      path += "red-dot.png"
    when 1
      path += "purple-dot.png"
    when 2
      path += "yellow-dot.png"
    when 3
      path += "green-dot.png"
    when 4 
      path += "ltblue-dot.png"
    end
    return path
  end
  
  def popularity_label(popularity)
    case Integer(popularity)
    when 0
      return "Very Popular"
    when 1
      return "Popular"
    when 2
      return "Common"
    when 3
      return "Uncommon"
    when 4 
      return "Rare"
    end
  end
  
  def marker_title(region)
    "Popular Names in " + escape_javascript(region.full_name) + " (" + region.current_year.to_s + ")"
  end
  
  def marker_title_with_pop(region, popularity)
    popularity_label(popularity) + " in " + escape_javascript(region.full_name) 
  end
end
