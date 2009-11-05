class AddBooksCounters < ActiveRecord::Migration
  def self.up
   add_column :langs, :books_count, :integer, :default => 0
   add_column :genres, :books_count, :integer, :default => 0
   add_column :bundles, :books_count, :integer, :default => 0
   Lang.update_all "books_count = 0"
   Genre.update_all "books_count = 0"
   Bundle.update_all "books_count = 0"
  end

  def self.down
   remove_column :langs, :books_count
   remove_column :genres, :books_count
   remove_column :bundles, :books_count
  end
end
