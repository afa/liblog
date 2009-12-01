class AddStateToBook < ActiveRecord::Migration
  def self.up
   add_column :books, :state, :string
  end

  def self.down
   remove_column :books, :state
  end
end
