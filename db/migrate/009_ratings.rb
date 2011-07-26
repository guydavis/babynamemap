class Ratings < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.create_ratings_table
    Name.add_ratings_columns
  end

  def self.down
    Name.remove_ratings_columns
    ActiveRecord::Base.drop_ratings_table
  end
end
