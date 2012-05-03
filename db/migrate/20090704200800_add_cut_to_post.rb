class AddCutToPost < ActiveRecord::Migration
  def self.up
   add_column :blog_posts, :cutted_text, :text
  end

  def self.down
   remove_column :blog_posts, :cutted_text
  end
end
