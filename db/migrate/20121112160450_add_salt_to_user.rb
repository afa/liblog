class AddSaltToUser < ActiveRecord::Migration
  def change
    add_column :users, :salt, :string
    add_column :users, :encrypted_password, :string
    add_column :users, :remember_token, :string
  end
end
