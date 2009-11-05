class AddRawtypeToBlog < ActiveRecord::Migration
  def self.up
   add_column :blog_posts, :raw_type, :string
  end

  def self.down
   remove_column :blog_posts, :raw_type
  end
end
