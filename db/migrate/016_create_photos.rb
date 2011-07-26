class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.column :parent_id, :integer
      t.column :name_id, :integer
      t.column :visitor_id, :integer
      t.column :last_name, :string
      t.column :location, :string
      t.column :birthday, :date
      t.column :moderated, :boolean, :default => false
      t.column :content_type, :string
      t.column :filename, :string    
      t.column :thumbnail, :string 
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :photos
  end
end
