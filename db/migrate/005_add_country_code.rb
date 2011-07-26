class AddCountryCode < ActiveRecord::Migration
  def self.up
    add_column :regions, :country_code, :string
  end

  def self.down
    remove_column :regions, :country_code
  end
end
