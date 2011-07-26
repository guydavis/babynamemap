class AddModeration < ActiveRecord::Migration
  def self.up
    add_column :comments, :moderated, :boolean, :default => false
  end

  def self.down
    remove_column :comments, :moderated
  end
end
