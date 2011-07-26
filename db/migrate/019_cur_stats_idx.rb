class CurStatsIdx < ActiveRecord::Migration
  def self.up
    add_index :current_stats, :name_id
    execute 'update names set is_popular = false'
    execute 'update names set is_popular = true where id in (select name_id from current_stats where count > 1)'
  end

  def self.down
    drop_index :current_stats, :name_id
  end
end
