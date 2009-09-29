class AddIndexToBlog < ActiveRecord::Migration
  def self.up
   add_index :blog_posts, [:created_at], :name=>'blog_posts_created_at_idx'
  end

  def self.down
   remove_index :blog_posts, 'blog_posts_created_at_idx'
  end
end
