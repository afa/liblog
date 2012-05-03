class RemoveUnusedFieldsFromUser < ActiveRecord::Migration
  def self.up
   remove_column :users, :can_admin
   remove_column :users, :can_post
   remove_column :users, :can_login
  end

  def self.down
   add_column :users, :can_admin, :boolean
   add_column :users, :can_post, :boolean
   add_column :users, :can_login, :boolean
  end
end
