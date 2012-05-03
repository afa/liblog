class AddContentFlagToBook < ActiveRecord::Migration
  def self.up
   add_column :books, :has_content, :boolean, :default=>false
   add_column :books, :bundled, :boolean, :default=>false
   Book.update_all "has_content = 'f', bundled = 'f'"
  end

  def self.down
   remove_column :books, :bundled
   remove_column :books, :has_content
  end
end
