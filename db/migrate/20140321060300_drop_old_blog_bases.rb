class DropOldBlogBases < ActiveRecord::Migration
  def up
    drop_table :blog_posts
    drop_table :blog_comments
  end
end
