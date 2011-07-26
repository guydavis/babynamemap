class CreateNames < ActiveRecord::Migration
  def self.up
    create_table :names do |t|
      t.column :name, :string, :null => false
      t.column :gender, :string
    end
  end

  def self.down
    drop_table :names
  end
end
