class AddLreFieldsToBook < ActiveRecord::Migration
  def self.up
   add_column :books, :lre_title, :string, :size=>1024
   add_column :books, :lre_annotation, :text
   add_column :books, :annotation, :text
   add_column :books, :lre_name_fixed, :string
  end

  def self.down
   remove_column :books, :lre_title
   remove_column :books, :lre_annotation
   remove_column :books, :lre_name_fixed
   remove_column :books, :annotation
  end
end
