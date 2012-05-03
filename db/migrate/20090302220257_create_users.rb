class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :username, :string
      t.column :identity_id, :integer
      t.column :password, :string
      t.column :can_admin, :boolean
      t.column :can_post, :boolean
      t.column :can_login, :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
