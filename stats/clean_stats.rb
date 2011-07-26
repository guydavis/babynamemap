#!/usr/bin/env ruby
#
# Given a WHERE CLAUSE for searching the names table, lets the admin either
# delete, skip, or migrate the stats to another name then delete.
#

require File.dirname(__FILE__) + '/../config/environment'

def print_n(name, action)
  if action
    puts action + " " + name.name + " (" + name.gender.capitalize + "-" + name.id.to_s + ")"
  else
    puts name.name + " (" + name.gender.capitalize + "-" + name.id.to_s + ")"
  end
end

# First strip leading or trailing white space
for name in Name.find_by_sql("select * from names where name like ' %' or name like '% '")
  print_n(name, "Trimming whitespace from ")
  name.name.strip!
  name.save
end

# Strip out the xxx... on the end of some names
for name in Name.find_by_sql("select * from names where name like '%xxx'")
  print_n(name, "Removing trailing xxx from ")
  name.name.sub!(/x+$/, '')
  name.save
end

# Delete any names without stats associated as they are orphans  (SLOW!!!)
# Put an index on stats.name_id to speed up
for name in Name.find(:all)
  count = Stat.connection.select_all("select count(*) stat_count from stats where name_id = " + 
    name.id.to_s)[0]['stat_count']
  if (Integer(count) == 0) 
    name.destroy
    print_n(name, "Deleted orphan ")
  end
end

# Update the is_popular value on a name to just those names currently used more than once
Name.connection.execute('update names set is_popular = false')
Name.connection.execute('update names set is_popular = true where id in (select name_id from current_stats where count > 1)')

if ARGV.size == 1  # Optionally can provide a LIKE clause
  for name in Name.find_by_sql("select * from names where name like '" + ARGV[0] + "'")
    print_n(name, "Enter action for name: ")
    action = STDIN.gets.strip
    if action == 'd'
      CurrentStat.delete_all(["name_id = ?", name.id])
      Stat.delete_all(["name_id = ?", name.id])
      name.destroy
      print_n(name, "Deleted name ")
    elsif action == 's'
      next # just continue to the next name
    end
  end
end


