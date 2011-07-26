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

class Region < ActiveRecord::Base
  has_many :stats
  acts_as_mappable :default_units => :kms, 
                   :default_formula => :flat, 
                   :distance_field_name => :distance

  def top_names(gender, num=5)
    names = Name.find_by_sql(["select n.*, s.rank, s.count from current_stats s " + \
       "inner join names n on s.name_id = n.id where s.rank <= " + num.to_s + " and s.region_id = ? " + \
       "and n.gender = ? order by rank", id, gender])
  end
  
  def full_name
    if region == country
      country
    else
      region + ", " + country
    end
  end
end
