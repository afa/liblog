class MoveIdentityToUser < ActiveRecord::Migration
  def self.up
   add_column :users, :name, :string
   add_column :blog_posts, :user_id, :integer
   User.reset_column_information
   BlogPost.reset_column_information
   Identity.all.each do |ident|
    ident.users.each do |u|
     u.update_attributes :name => ident.name
    end
   end
   BlogPost.all.each do |post|
    post.update_attributes :user_id => (post.identity.try(:users) || [User.where(:username => 'afa').first.id]).first
   end
  end

  def self.down
   remove_column :blog_posts, :user_id
   remove_column :users, :name
  end
end
