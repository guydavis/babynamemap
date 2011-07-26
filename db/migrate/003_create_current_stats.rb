class CreateCurrentStats < ActiveRecord::Migration
  def self.up
    create_table :current_stats do |t|
      t.column :region_id, :integer
      t.column :name_id, :integer
      t.column :year, :integer
      t.column :count, :integer
      t.column :rank, :integer
      t.column :popularity, :integer, :limit=>1
    end
  end

  def self.down
    drop_table :current_stats
  end
end
