class CreateSiteConfigs < ActiveRecord::Migration
  def self.up
    create_table :site_configs do |t|
      t.column :name, :string
      t.column :value, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :site_configs
  end
end
