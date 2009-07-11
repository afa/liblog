class FixBlogPostCounter < ActiveRecord::Migration
  def self.up
   remove_column :blog_posts, :comments_count
   add_column :blog_posts, :comments_count, :integer, :default=>0
  end

  def self.down
   remove_column :blog_posts, :comments_count
   add_column :blog_posts, :comments_count, :integer
  end
end
