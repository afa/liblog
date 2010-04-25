class AddStateToBlogPost < ActiveRecord::Migration
  def self.up
   add_column :blog_posts, :state, :string, :default=>'created'
  end

  def self.down
   remove_column :blog_posts, :state
  end
end
