class AddFileNameToBooks < ActiveRecord::Migration
  def self.up
   add_column :books, :file_name, :string
  end

  def self.down
   remove_column :books, :file_name
  end
end
