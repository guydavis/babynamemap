#
# Common functions used by the various statistics loaders for different regions
#
def capitalize(name_in_bad_case)
  name = name_in_bad_case.capitalize 
  for sep in ["-", "'", " "]
    if name.index(sep)
      name = name.chars.split(sep).collect {|x| x.chars.capitalize}.join(sep)
      break
     end
  end
  return name
end

def load_stat(fname, count, year, gender, region)
  if not fname
    return -1
  end

  name = Name.find(:first, :conditions => [ "name = ? and gender = ?",
    fname, gender])
  if not name
    name = Name.new
    name.name = fname
    name.gender = gender
    name.save
  end

  stat = Stat.find(:first, :conditions => [
    "region_id = ? and year = ? and name_id = ?",
    region.id, year, name.id])
  if (not stat)
    stat = Stat.new
    stat.name = name
    stat.region = region
    stat.year = year
  end
  stat.count = count
  stat.save

  # Store a current stat in current archive if most recent year
  if (year == region.current_year)
    current_stat = CurrentStat.find(:first, :conditions => [
      "region_id = ? and year = ? and name_id = ?",
      region.id, year, name.id])
    if (not current_stat)
      current_stat = CurrentStat.new
      current_stat.name = name
      current_stat.region = region
      current_stat.year = year
    end
    current_stat.count = count
    current_stat.save
  end
end


# For stats where only the rank is provided (Only for top 100 or so!)
# Since we only have rank, only CurrentStats are created as Stats require count
def load_stat_by_rank(fname, rank, year, gender, region)
  if not fname
    return -1
  end

  # Store a current stat in current archive if most recent year
  if (year == region.current_year)
    name = Name.find(:first, :conditions => [ "name = ? and gender = ?",
      fname, gender])
    if not name
      name = Name.new
      name.name = fname
      name.gender = gender
      name.save
    end

    current_stat = CurrentStat.find(:first, :conditions => [
      "region_id = ? and year = ? and name_id = ?",
      region.id, year, name.id])
    if (not current_stat)
      current_stat = CurrentStat.new
      current_stat.name = name
      current_stat.region = region
      current_stat.year = year
    end
    current_stat.rank = rank

    if rank <= 10
      current_stat.popularity = 0
    else # Assume the rest are top 100 and thus pop is Popular
      current_stat.popularity = 1
    end
    current_stat.save
  end
end


def calc_popularity(gender, region)
  CurrentStat.delete_all(["region_id = ? and year < ?", region.id, region.current_year])
  most_popular_stat = CurrentStat.find_by_sql(["select s.* from current_stats s, names n where s.name_id = n.id and region_id = ? and n.gender = ? order by count desc limit 1", region.id, gender])[0]
  stats = CurrentStat.find_by_sql ["select s.* from current_stats s, names n where s.name_id = n.id and region_id = ? and n.gender = ? order by count desc", region.id, gender]
  rank = 1
  for stat in stats
    stat.rank = rank
    if rank <= 10
      stat.popularity = 0 # Top 10 name = Very Popular
    elsif stat.count >= most_popular_stat.count * 0.15
      stat.popularity = 1 # Count is at least 15% of max = Popular
    elsif stat.count >= most_popular_stat.count * 0.05
      stat.popularity = 2 # Count is at least 5% of max = Common
    elsif stat.count >= most_popular_stat.count * 0.01
      stat.popularity = 3 # Count is at least 1% of max = Uncommon
    else
      stat.popularity = 4 # Very low count = Rare
    end
    stat.save
    rank = rank + 1
  end
end
