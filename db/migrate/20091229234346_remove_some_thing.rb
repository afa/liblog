class RemoveSomeThing < ActiveRecord::Migration
  def self.up
   remove_column :things, :some_things_id
  end

  def self.down
   
  end
end
