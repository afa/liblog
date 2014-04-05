class CreateBlogsPosts < ActiveRecord::Migration
  def self.up
    create_table :blog_posts do |t|
      t.column :title, :string
      t.column :text, :text
      t.column :identity_id, :integer
      t.column :name, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :blog_posts
  end
end
