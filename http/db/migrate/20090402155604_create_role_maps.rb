class CreateRoleMaps < ActiveRecord::Migration
  def self.up
    create_table :role_maps do |t|
     t.column :user_id, :integer
     t.column :role_id, :integer
    end
  end

  def self.down
    drop_table :role_maps
  end
end
