class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
      t.column :region_id, :integer
      t.column :name_id, :integer
      t.column :year, :integer
      t.column :count, :integer
    end
  end

  def self.down
    drop_table :stats
  end
end
