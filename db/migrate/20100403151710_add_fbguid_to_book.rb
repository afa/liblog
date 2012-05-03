class AddFbguidToBook < ActiveRecord::Migration
  def self.up
   add_column :books, :fbguid, :string
   add_index :books, [:fbguid]
  end

  def self.down
   remove_column :books, :fbguid
  end
end
