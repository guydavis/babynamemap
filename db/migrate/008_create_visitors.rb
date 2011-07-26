class CreateVisitors < ActiveRecord::Migration
  def self.up
    create_table :visitors do |t|
      t.column :ip_addr, :string
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :visitors
  end
end
