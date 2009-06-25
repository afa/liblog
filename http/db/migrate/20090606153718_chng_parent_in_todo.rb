class ChngParentInTodo < ActiveRecord::Migration
  def self.up
   add_column :to_dos, :parent_id, :integer
   add_column :to_dos, :prio_level, :integer
   add_column :to_dos, :priority, :integer
   ToDo.find(:all).each do | i |
    i.parent_id = i.parent
    i.save
   end
   remove_column :to_dos, :parent
  end

  def self.down
   add_column :to_dos, :parent, :integer
   remove_column :to_dos, :prio_level
   remove_column :to_dos, :priority
   ToDo.find(:all).each do | i |
    i.parent = i.parent_id
    i.save
   end
   remove_column :to_dos, :parent_id
  end
end
