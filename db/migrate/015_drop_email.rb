class DropEmail < ActiveRecord::Migration
  def self.up
    remove_column :visitors, :email
  end

  def self.down
    add_column :visitors, :email, :string
  end
end
