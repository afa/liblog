class AddDoneToToDo < ActiveRecord::Migration
  def self.up
   add_column :to_dos, :done, :boolean
  end

  def self.down
   remove_column :ToDo, :done
  end
end
