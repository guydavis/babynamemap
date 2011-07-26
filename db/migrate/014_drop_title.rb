class DropTitle < ActiveRecord::Migration
  def self.up
    remove_column :comments, :title
  end

  def self.down
    add_column :comments, :title, :string
  end
end
