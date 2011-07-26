class Extjs2 < ActiveRecord::Migration
  def self.up
    execute 'update regions set country = "United States" where country = "USA"'
    add_column :regions, :is_country, :boolean, :default => false  
    execute 'update regions set is_country = true where region = country'
    add_column :regions, :has_icon, :boolean, :default => false
    execute 'update regions set region_code = "en", has_icon = true where id = 60'
    execute 'update regions set region_code = "sc", has_icon = true where id = 57'
    execute 'update regions set region_code = "wa", has_icon = true where id = 59'
    execute 'update regions set region_code = "ni", has_icon = true where id = 58'
end

  def self.down
    remove_column :regions, :is_country
    remove_column :regions, :has_icon
  end
end
