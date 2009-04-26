class CreatePrivilegeMaps < ActiveRecord::Migration
  def self.up
    create_table :privilege_maps do |t|
     t.column :privilege_id, :integer
     t.column :role_id, :integer
    end
  end

  def self.down
    drop_table :privilege_maps
  end
end
