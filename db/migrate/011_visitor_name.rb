class VisitorName < ActiveRecord::Migration
  def self.up
    add_column :visitors, :name, :string
    add_column :visitors, :email, :string
  end

  def self.down
    remove_column :visitors, :name
    remove_column :visitors, :email
  end
end
