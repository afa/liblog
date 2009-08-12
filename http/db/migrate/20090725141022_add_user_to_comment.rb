class AddUserToComment < ActiveRecord::Migration
  def self.up
   add_column :blog_comments, :user_id, :integer, :null=>false, :default=>false
  end

  def self.down
   remove_column :blog_comments, :user_id
  end
end
