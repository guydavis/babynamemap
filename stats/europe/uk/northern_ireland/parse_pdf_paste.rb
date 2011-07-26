#!/usr/bin/env ruby
#
# The Northern Ireland data is in a PDF that I copied/pasted from.  However,
# it puts one line for each cell and I only need the current years count and
# the name.
#
# http://www.nisra.gov.uk/demography/default.asp?cmsid=20_45_53&cms=demography_Publications_Baby+Names&release=
#

File.open(ARGV[0]) do | file |
  cell = 0
  while line = file.gets
    if cell == 0
      name = line.strip
    elsif cell == 3
      count = Integer(line.strip)
    elsif cell == 5
      puts name + '    ' + count.to_s
      cell = -1 # reset for next row
    end
    cell = cell + 1	
  end
end
