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

class Photo < ActiveRecord::Base
  belongs_to :name
  belongs_to :visitor

  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :max_size => 5.megabytes,
                 :resize_to => '420x315>',
                 :thumbnails => { :thumb => '140x160>' },
                 :processor => 'Rmagick',
                 :path_prefix => 'public/system/photos'

  validates_as_attachment
end
