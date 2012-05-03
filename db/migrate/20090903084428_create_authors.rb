class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors do |t|
      t.string :first_name
      t.string :last_name
      t.integer :books_count
      t.timestamps
    end
   create_table :authors_books, :id=>false do |t|
    t.integer :book_id
    t.integer :author_id
   end
   add_index :authors, [:last_name, :first_name], :name=>'authors_name_uniq_idx', :uniq=>true
   add_index :authors_books, [:book_id, :author_id], :name=>'authors_books_uniq_idx', :uniq=>true
  end

  def self.down
   remove_index :authors, 'authors_name_uniq_idx'
   remove_index :authors_books, 'authors_books_uniq_idx'
    drop_table :authors
   drop_table :authors_books
  end
end
