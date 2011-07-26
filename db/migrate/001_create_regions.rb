class CreateRegions < ActiveRecord::Migration
  def self.up
    create_table :regions do |t|
      t.column :country, :string, :null => false
      t.column :region, :string, :null => false
      t.column :region_code, :string, :null => false
      t.column :lat, :decimal, :precision => 10, :scale => 6, :null => false
      t.column :lng, :decimal, :precision => 10, :scale => 6, :null => false
      t.column :stats_name, :string, :null => false
      t.column :stats_desc, :string
      t.column :stats_url, :string
      t.column :current_year, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :regions
  end
end
