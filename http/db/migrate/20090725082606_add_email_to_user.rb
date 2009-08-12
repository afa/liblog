class AddEmailToUser < ActiveRecord::Migration
  def self.up
   add_column :users, :email, :string
   add_index :users, [:email, :identity_id], :unique=>true
  end

  def self.down
   remove_index :index_users_on_email_identity_id
   remove_column :users, :email
  end
end
