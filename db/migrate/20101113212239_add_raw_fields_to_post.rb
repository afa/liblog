class AddRawFieldsToPost < ActiveRecord::Migration
  def self.up
    add_column :blog_posts, :raw_tail, :text
    add_column :blog_posts, :raw_cut_string, :string
  end

  def self.down
    remove_column :blog_posts, :raw_tail
    remove_column :blog_posts, :raw_cut_string
  end
end
