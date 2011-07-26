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

class Name < ActiveRecord::Base
  has_many :current_stats 
  has_many :stats
  has_many :photos
  
  acts_as_rated :rater_class => 'Visitor'
  acts_as_commentable
  
  Genders = {
    :male => "MALE", 
    :female =>"FEMALE"
    }
  validates_inclusion_of :gender, :in => Genders.values
  
  def to_s
    name + ' (' + gender.capitalize + ')'
  end
  
  def moderated_comments
    moderated = Array.new
    for comment in comments
      if comment.moderated
        moderated << comment
      end
    end
    return moderated
  end
  
  def moderated_photos
    moderated = Array.new
    for photo in photos
      if photo.moderated
        moderated << photo
      end
    end
    return moderated
  end
  
end
