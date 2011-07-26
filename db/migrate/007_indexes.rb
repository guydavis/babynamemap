class Indexes < ActiveRecord::Migration
  def self.up
    add_index :names, [:name, :gender], :unique => true
    add_index :stats, [:region_id, :year, :name_id], :unique => true
    add_index :current_stats, [:region_id, :year, :name_id], :unique => true
  end

  def self.down
  end
end
