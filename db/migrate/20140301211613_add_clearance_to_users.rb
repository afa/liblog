class AddClearanceToUsers < ActiveRecord::Migration
  def self.up
    change_table :users  do |t|
      t.string :confirmation_token, :limit => 128
    end

    add_index :users, :email
    add_index :users, :remember_token
  end

  def self.down
    change_table :users do |t|
      t.remove :confirmation_token
    end
  end
end
