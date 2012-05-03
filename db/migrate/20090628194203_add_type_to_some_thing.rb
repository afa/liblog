class AddTypeToSomeThing < ActiveRecord::Migration
  def self.up
   add_column :some_things, :type, :string
  end

  def self.down
   remove_column :some_things, :type
  end
end
