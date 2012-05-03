class AddProjIdToTodo < ActiveRecord::Migration
  def self.up
   add_column :to_dos, :project_id, :integer
  end

  def self.down
   remove_column :to_dos, :project_id
  end
end
