class RemoveSomeThing < ActiveRecord::Migration
  def self.up
   drop_table :some_things
   remove_column :things, :some_things_id
  end

  def self.down
   
  end
end
