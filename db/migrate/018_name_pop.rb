class NamePop < ActiveRecord::Migration
  def self.up
    add_column :names, :is_popular, :boolean, :default => false
    execute 'update names set is_popular = true where id in (select name_id from stats where count > 1)'
    add_index :names, :is_popular
  end

  def self.down
    remove_column :names, :is_popular
  end
end
