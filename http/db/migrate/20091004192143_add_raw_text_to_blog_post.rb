class AddRawTextToBlogPost < ActiveRecord::Migration
  def self.up
   add_column :blog_posts, :raw_text, :text
   add_column :blog_posts, :raw_header, :text
  end

  def self.down
   remove_column :blog_posts, :raw_text
   remove_column :blog_posts, :raw_header
  end
end
