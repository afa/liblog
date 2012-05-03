class CreateIdentities < ActiveRecord::Migration
  def self.up
    create_table :identities do |t|
      t.column :name, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :identities
  end
end
