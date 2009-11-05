class AddFieldsToThing < ActiveRecord::Migration
  def self.up
   add_column :things, :thingable_id, :integer, :null=>false
   add_column :things, :thingable_type, :string
   add_column :things, :type, :string
  end

  def self.down
   remove_column :things, :thingable_id
   remove_column :things, :thingable_type
   remove_column :things, :type
  end
end
