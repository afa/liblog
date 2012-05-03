class AddAuthorToArticle < ActiveRecord::Migration
  def self.up
   add_column :articles, :author_id, :integer
   add_column :articles, :source_path, :string
  end

  def self.down
   remove_column :articles, :author_id
   remove_column :articles, :source_path
  end
end
