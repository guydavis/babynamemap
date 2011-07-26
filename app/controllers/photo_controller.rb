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

class PhotoController < ApplicationController
  layout "admin"
  active_scaffold do |config|
    config.label = "Photos"
    config.columns = [:created_at, :filename, :name, :last_name, :location, :moderated]
    list.columns.exclude :birthday, :content_type, :width, :height, :thumbnail, 
      :size, :visitor, :parent, :thumbnails
    list.sorting = {:created_at => 'DESC'}
    config.update.columns = [:last_name, :location, :birthday, 
      :moderated]
    columns[:filename].label="Photo"
    config.show.columns = [:filename, :birthday, :name, :last_name, :location, 
      :created_at, :moderated, :content_type, :width, :height, :size]
  end
  
  def conditions_for_collection
    ["thumbnail is null"]
  end
end
  