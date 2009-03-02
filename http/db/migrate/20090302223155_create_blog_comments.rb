class CreateBlogComments < ActiveRecord::Migration
  def self.up
    create_table :blog_comments do |t|
      t.column :title, :string
      t.column :text, :text
      t.column :blog_post_id, :integer
      t.column :blog_comment_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :blog_comments
  end
end
