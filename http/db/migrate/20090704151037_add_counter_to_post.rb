class AddCounterToPost < ActiveRecord::Migration
  def self.up
   add_column :blog_posts, :comments_count, :integer, :default=>0
  end

  def self.down
   remove_column :blog_posts, :comments_count
  end
end
